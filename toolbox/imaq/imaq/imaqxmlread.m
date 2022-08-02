function [props, sources] = imaqxmlread(xmlPath, boardName, videoFormat, uddEnumTypeStr)
%IMAQXMLREAD Parse image acquisition XML configuration file.
% 
%    [PROPS, SRCS] = IMAQXMLREAD(XMLPATH, BOARDNAME, VIDEOFORMAT, UDDENUMTYPESTR)
%    parses the XML configuration file, specified by XMLPATH, for vendor specific 
%    information.
%
%    Vendor specific information for the specified BOARDNAME and
%    VIDEOFORMAT is returned in PROPS, a structure array of properties,
%    and SRCS, a structure array of sources.
%
%    For properties requiring an enumerated property to be created, the
%    UDDENUMTYPESTR is used to distinguish between properties of the same name
%    when using different enumerated values for different devices.
%
%    IMAQXMLREAD is a helper function used by the Image Acquisition Toolbox.
% 
%    See also VIDEOINPUT, IMAQHELP.
%

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:03 $

% Initialize output variables so we can return 
% without nonexistant outputs.
props.parent = [];
props.channel = [];
sources = [];

% Return immediately if there is no XML file to read.
if exist(xmlPath)==0,
    return;
end

% Read XML file.
node = xmlread(xmlPath);

% Verify this is an Image Acquisition configuration file.
imaqNode = node.getElementsByTagName('ImageAcquisitionVendorInfo');
if imaqNode.getLength ~= 1
    return;
end

% get the device element matching the specific boardName
devElement = localFindElement(imaqNode.item(0),'Device',boardName);

% Is specified board name not found?
if isempty(devElement)
    return;
end

% Get the device-level properties, if any.
[props sources] = localGetProperties(devElement, uddEnumTypeStr, devElement, videoFormat,[],[]);

% For each board, search it's video groups.
videoElement = localFindElement(devElement,'VideoFormat',videoFormat);

% Specified video format was not found.
if isempty(videoElement),
    return;
end

% Get the video-format-level properties, if any.
[props sources] = localGetProperties(videoElement, uddEnumTypeStr, devElement, videoFormat, props, sources);

% Make sure there actually are some channel sets.
if isempty(sources)
    props = [];
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Return child nodes with specified element name and 'name' attribute
function node = localFindElement(node,elementName, nameAttribute)

% Determine how many nodess we need to check.
elements = node.getElementsByTagName(elementName);
nElements = elements.getLength;

% For each board element, check the board name.
% Note: Indexing is 0 based.
node = [];
for i=0:nElements-1,
    % Check for specified board name (or attributes global to all boards).
    if any(strcmp(nameAttribute, char(elements.item(i).getAttribute('name'))))
        node = elements.item(i);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Return current properties and channel-properties of a node
function [props, sources, channels] = localGetProperties(node, uddEnumTypeStr, includeRoot, videoFormat, props, sources)

if isempty(props)
    props.parent = [];
    props.channel = [];
end
if isempty(sources)
    sources = [];
end
channels = [];

propNode = node.getFirstChild;
while ~isempty(propNode)
    switch lower(char(propNode.getNodeName))
        case 'property'
            s = localExtractProperty(propNode, uddEnumTypeStr);
            props.parent = [props.parent s];
        case 'channelproperty'
            s = localExtractProperty(propNode, uddEnumTypeStr);
            props.channel = [props.channel s];
        case 'source'
            src.name = char(propNode.getAttribute('name'));
            id = propNode.getAttribute('id');
            if isempty(id)
                src.id = length(sources);
            else
                src.id = str2double(id);
            end
            % process the source node
            [props sources ch] = localGetProperties(propNode,uddEnumTypeStr,includeRoot, videoFormat, props, sources);
            src.channels = ch;
            sources = [sources src];
        case 'channel'
            ch.name = char(propNode.getAttribute('name'));
            id = propNode.getAttribute('id');
            if isempty(id)
                ch.id = length(sources);
            else
                ch.id = str2double(id);
            end            
            channels = [channels ch];
        case 'include'
            tag = char(propNode.getAttribute('tag'));
            includeNode = includeRoot.getElementsByTagName(tag);
            for lcv=0:includeNode.getLength-1
                [props sources] = localGetProperties(includeNode.item(lcv),uddEnumTypeStr,includeRoot, videoFormat, props, sources);
            end 
    end
        
    propNode = propNode.getNextSibling;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract property structure from the specified property element node
function s = localExtractProperty(propNode, uddEnumTypeStr)

% For each element, extract property information.
s.Name = char(propNode.getAttribute('name'));
s.Type = char(propNode.getAttribute('type'));        
s.Constraint = char(propNode.getAttribute('constraint'));
s.ReadOnly = char(propNode.getAttribute('readOnly'));
s.DeviceSpecific = strcmp('true', char(propNode.getAttribute('deviceSpecific')));

% Define the help for this property.
helpValElements = propNode.getElementsByTagName('Help');
if (helpValElements.getLength) && (helpValElements.item(0).getLength)
    s.Help = char(helpValElements.item(0).item(0).getNodeValue);
else
    s.Help = '';
end


% Determine the necessary constraint values according to the
% property constraint. For enum constraints, a UDD Enum data type
% name is required.
s.ConstraintValue = {};
s.ConstraintId = [];

switch s.Constraint,
    case 'enum'
        % Construct a new UDD data type class name if required.
        %
        % Note:
        %    Since different T&M products may have the same property 
        % with different enum values, make it unique to IMAQ.
        % This will later on be made more unique by using the UDD class name
        % since IMAQ device 0 and 1 may have the same property, with 
        % different enums.
        s.UDDTypeName = [uddEnumTypeStr, '_', s.Name, 'IMAQEnumType'];
        
        % Enum constraint requires a list of enum constraint values.
        constrValElements = propNode.getElementsByTagName('EnumConstraintValue');
        nConstrValElements = constrValElements.getLength;
        
        % Make sure enum constraint values were provided.
        if nConstrValElements == 0,
            warning('imaq:imaqxmlread:malformedproperty', ['XML file is malformed for property ' s.Name]);
            props = [];
            return;
        end
        
        % Create a cell array of enum values.
        for j=0:nConstrValElements-1,
            constrValNode = constrValElements.item(j);
            s.ConstraintValue = {s.ConstraintValue{:} char(constrValNode.getAttribute('name'))};
            s.ConstraintId = [s.ConstraintId str2double(constrValNode.getAttribute('id'))];
        end
    case 'bounded'
        % Set UDD data type name.
        s.UDDTypeName = 'double';
        
        % Bounded constraint requires a min and max constraint value.
        maxConstrValElement = propNode.getElementsByTagName('MaxConstraintValue');
        minConstrValElement = propNode.getElementsByTagName('MinConstraintValue');
        
        % A max and min value is required.
        if ~( (maxConstrValElement.getLength) && (minConstrValElement.getLength) ),
            warning(['XML file is malformed for property ' s.Name]);
            props = [];
            return;
        end
        
        % Create the constraint vector
        min = str2double(minConstrValElement.item(0).item(0).getNodeValue);
        max = str2double(maxConstrValElement.item(0).item(0).getNodeValue);
        s.ConstraintValue = [min max];
    case 'cell'
        % Set UDD data type name.
        s.UDDTypeName = 'string vector';
    otherwise
        % Default constraint value.
        s.ConstraintValue = '';
        s.UDDTypeName = 'MATLAB array';
end
% Determine the default value.
switch s.Type
    case 'cell',
        % Create the default value for cell types. The default value for a cell type
        % is defined one cell entry at a time.
        defCellElements = propNode.getElementsByTagName('DefaultCellValue');
        nDefCellElements = defCellElements.getLength;
        
        % Make sure values were provided.
        if nDefCellElements == 0,
            warning(['XML file is malformed for property ' s.Name]);
            props = [];
            return;
        end
        
        % Create a cell array of enum values.
        defVals = {};
        for j=0:nDefCellElements-1,
            defValNode = defCellElements.item(j);
            defVals = {defVals{:} char(defValNode.item(0).getNodeValue)};
        end
        s.DefaultValue = defVals;
    case 'string'
        defaultValElements = propNode.getElementsByTagName('DefaultValue');
        s.DefaultValue = char(defaultValElements.item(0).item(0).getNodeValue);
    case 'double'
        defaultValElements = propNode.getElementsByTagName('DefaultValue');
        s.DefaultValue = str2double(defaultValElements.item(0).item(0).getNodeValue);
    otherwise
        % Extract the default value.
        defaultValElements = propNode.getElementsByTagName('DefaultValue');
        s.DefaultValue = defaultValElements.item(0).item(0).getNodeValue;
end
