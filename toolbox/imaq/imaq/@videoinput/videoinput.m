function obj = videoinput(varargin)
%VIDEOINPUT Create a video input object.
% 
%    OBJ = VIDEOINPUT(ADAPTORNAME)
%    OBJ = VIDEOINPUT(ADAPTORNAME, DEVICEID)
%    OBJ = VIDEOINPUT(ADAPTORNAME, DEVICEID, FORMAT) constructs a video input
%    object, OBJ, using:
%
%        ADAPTORNAME - a string specifying the device adaptor OBJ is associated
%                      with. Valid values can be determined by using the 
%                      IMAQHWINFO function.
%        DEVICEID    - a numerical device identifier. If DEVICEID is not 
%                      specified, the first available device ID is used.
%        FORMAT      - a string specifying the video format for OBJ. If FORMAT 
%                      is not specified, the device's default format is used.
%
%    Valid DEVICEID and FORMAT values, as well as the default format, can be 
%    determined by using the IMAQHWINFO(ADAPTORNAME) syntax.
%
%    Upon creation, OBJ's VideoFormat property will reflect the specified 
%    FORMAT. The first available video source will also be selected and 
%    indicated by OBJ's SelectedSourceName property. Use GETSELECTEDSOURCE(OBJ)
%    to access the video source object that will be used for acquisition.
%
%    As a convenience, a device's name may be used in place of the DEVICEID. If
%    multiple devices have the same name, the first available device is used.
% 
%    OBJ = VIDEOINPUT(ADAPTORNAME, DEVICEID, DEVICEFILENAME) constructs a video
%    input object, OBJ, using a device configuration file, DEVICEFILENAME as
%    the video format. OBJ's VideoFormat property will reflect the 
%    DEVICEFILENAME and its path.
%
%    OBJ = VIDEOINPUT(ADAPTORNAME, DEVICEID, FORMAT, 'P1', V1, 'P2', V2, ...) 
%    OBJ = VIDEOINPUT(ADAPTORNAME, DEVICEID, DEVICEFILENAME, 'P1', V1, ...)
%    constructs a video input object with the specified property values. 
%    If an invalid property  name or property value is specified the 
%    object will not be created.
%  
%    Note that the property value pairs can be in any format supported by 
%    the SET function, i.e., param-value string pairs, structures, and 
%    param-value cell array pairs.  
%  
%    For a complete listing of video input functions and properties, use the 
%    IMAQHELP function, i.e., imaqhelp videoinput.
% 
%    Example:
%       % Construct a video input object associated 
%       % with a Matrox device at ID 1:
%       obj = videoinput('matrox', 1);
%
%       % Select the source to use for acquisition. 
%       set(obj, 'SelectedSourceName', 'input1')
%
%       % View the properties for the selected video source object.
%       src_obj = getselectedsource(obj);
%       get(src_obj)
%
%       % Preview a stream of image frames:
%       preview(obj);
%
%       % Acquire and display a single image frame:
%       frame = getsnapshot(obj);
%       image(frame);
%
%       % Remove video input object from memory:
%       delete(obj);
% 
%    See also IMAQHELP, IMAQHWINFO, IMAQDEVICE/GET, IMAQDEVICE/SET, 
%             IMAQDEVICE/GETSELECTEDSOURCE, IMAQDEVICE/PROPINFO.

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.5 $  $Date: 2004/03/30 13:05:46 $

% Initializing fields for MATLAB OOPs object.
className = 'videoinput';
parentClassName = 'imaqdevice';
try
    obj.version = imaqmex;
catch
    rethrow(lasterror)
end
obj.type = {className};
obj.constructor = className;
obj.data.objtype = 'Video Input';

% Create the parent for the class.
parent = imaqdevice(parentClassName);

%%%%%%%%%%%%%%%%%%%%%%%%
% Parse Input Arguments.
%
% Syntax checking is performed later. For now, just extract
% the the inputs into our own variables.
PVpairs = {};
switch(nargin),
case 0,
    % Default constructor.
    errID = 'imaq:videoinput:adaptorID';
    error(errID, imaqgate('privateMsgLookup', errID));
case 1,
    if strcmp(class(varargin{1}), className)
        % Return the object as is.
        obj = varargin{1};
        return;
    elseif ~isempty(strfind( class(varargin{1}), 'imaq.') ) || ...
            strcmp(class(varargin{1}), 'handle'),
        % Note: Can't just use ISHANDLE here. Need to check the class since 
        %       we could encounter videoinput(audiorecorder).
        %
        % Also, we need to allow inputs of class hanlde in order to load
        % invalid objects via LOADOBJ.
        %
        % This is used by SUBSREF/SUBSASGN/IMAQFIND to convert a UDD object
        % to the proper MATLAB OOPS class.
        %
        % Store UDD object and create new MATLAB object.
        obj.uddobject = varargin{1};
        obj = class(obj, className, parent);
        return;
    elseif isstruct(varargin{1}) && isfield(varargin{1}, parentClassName) && ...
            isa(varargin{1}.imaqdevice, parentClassName),
        % We were provided a previously constructed videoinput structure.
        %
        % Note: Since MATLAB adds a field for the parent when
        %       creating a new object with CLASS, we first need 
        %       to remove the existing dummy parent object.
        objStruct = rmfield(varargin{1}, parentClassName);
        obj = class(objStruct, className, parent);
        return;
    else
        % obj = videoinput('matrox');
        % Leave format and device ID option empty for now. We'll use defaults later.
        adaptorName = varargin{1};
        deviceID = [];
        formatType = '';
    end
case 2,
    % obj = videoinput('matrox', 1);
    % Leave format option empty for now. We'll use default FORMAT later.
    adaptorName = varargin{1};
    deviceID = varargin{2};        
    formatType = '';
otherwise,
    % Check the syntax case used later on. For now, assume 3rd input is 
    % the format option.
    adaptorName = varargin{1};
    deviceID = varargin{2};
    formatType = varargin{3};
end

%%%%%%%%%%%%%%%%%%%%%%%%
% Input Error Checking
%
% Convert string ID's to a double. Provided as a convenience.
if ischar(deviceID),    
    % If the device ID is a non-numeric string (like 'Intel Camera'), 
    % NaN is returned. Since device names are also accepted, keep the 
    % old device ID if this turns out to be the case.
    tempDeviceID = str2double(deviceID);
    if ~isnan(tempDeviceID),
        deviceID = tempDeviceID;
    end
end

% Device ID error checking.
if nargin>1,
    % Allow non-double numerics to come through.
    if isnumeric(deviceID) && ~isa(deviceID, 'double'),
        deviceID = double(deviceID);
    end
    
    if isempty(deviceID)
        errID = 'imaq:videoinput:emptyID';
        error(errID, imaqgate('privateMsgLookup', errID));
    elseif ~isa(deviceID, 'double') && ~ischar(deviceID),
        errID = 'imaq:videoinput:notAnID';
        error(errID, imaqgate('privateMsgLookup', errID));
    elseif deviceID < 0
        errID = 'imaq:videoinput:negativeID';
        error(errID, imaqgate('privateMsgLookup', errID));
    end
end

% Source format error checking.
if ~ischar(formatType)
    errID = 'imaq:videoinput:strFormat';
    error(errID, imaqgate('privateMsgLookup', errID));
end

% Adaptor name error checking.
if ~ischar(adaptorName)
    errID = 'imaq:videoinput:strAdaptor';
    error(errID, imaqgate('privateMsgLookup', errID));
elseif isempty(adaptorName)
    errID = 'imaq:videoinput:emptyAdaptor';
    error(errID, imaqgate('privateMsgLookup', errID));
end

% Locate the adaptor files. 
adaptorName = lower(adaptorName);
try
    hwInfo = imaqhwinfo(adaptorName);
catch
    rethrow(lasterror);
end

% Check that device are actually available.
if isempty(hwInfo.DeviceIDs),
    errID = 'imaq:videoinput:noDevices';
    error(errID, imaqgate('privateMsgLookup', errID));
end

% DLLs are PC specific.
if ispc,
    xmlPath = strrep(hwInfo.AdaptorDllName, '.dll', '.imdf');
    % Make sure the file exists.
    if exist(xmlPath)==0,
        xmlPath = '';
    end
end

% If no device ID was specified, use the first one.
if isempty(deviceID),
    deviceID = hwInfo.DeviceIDs{1};
end

% Locate the numerical device ID if we are dealing with numerical IDs.
infoIndex = [];
if ~ischar(deviceID),
    infoIndex = find(deviceID == [hwInfo.DeviceIDs{:}]);
end

% Verify that IMAQHWINFO is available for this adaptor.
if isempty(infoIndex),
    % We're may be dealing withe device names. Check if there's 
    % a match for the device name provided.
    deviceNameMatch = strcmpi(deviceID, {hwInfo.DeviceInfo.DeviceName});
    nameMatchIndices = find(deviceNameMatch==true);
    if ~isempty(nameMatchIndices)
        % A device name was provided. Use the ID for the first match.
        infoIndex = nameMatchIndices(1);
        deviceID = hwInfo.DeviceIDs{infoIndex};
    else
        errID = 'imaq:videoinput:invalidID';
        error(errID, imaqgate('privateMsgLookup', errID));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Syntax Checking
%
% Determine the board name, supported formats, and the 
% format to use.
requestedDevice = hwInfo.DeviceInfo(infoIndex);
deviceFileOK = requestedDevice.DeviceFileSupported;
defaultFormat = requestedDevice.DefaultFormat;
supportedFormats = requestedDevice.SupportedFormats;
checkSupported = strcmpi(formatType, supportedFormats);

% Based on the syntax called, determine the format option and
% extract any PV pairs present.
if isempty(formatType),
    % Checking:
    %   obj = videoinput('matrox', 1);
    %
    % We need to assign the default format from IMAQHWINFO.
    formatType = defaultFormat;
elseif nargin>=3,
    if any(checkSupported),
        % Checking:
        %   obj = videoinput('matrox', 1, 'rs170', ...);
        %
        % No PV pairs to extract, so keep it empty.
        % Use the format name from IMAQHWINFO to preserve case.
        supportedIndex = find(checkSupported==true);
        formatType = supportedFormats{supportedIndex(1)};
    else
        % Checking:
        %   obj = videoinput('matrox', 1, 'D:\MyCameraFile.dcf', ...);
        %
        % The format is already set to the camera file. Make sure the
        % file includes a path.
        [formatType, fileFlag] = localAddPathToFile(formatType);
        if ~deviceFileOK && fileFlag,
            % User input looked like DEVICEFILE, but device 
            % doesn't support them.
            errID = 'imaq:videoinput:noFile';
            error(errID, imaqgate('privateMsgLookup', errID));
        elseif ~fileFlag && ~deviceFileOK
            % User input looked like FORMAT.
            errID = 'imaq:videoinput:noFormat';
            error(errID, imaqgate('privateMsgLookup', errID));            
        end
    end
    
    % Checking:
    %   obj = videoinput('matrox', 1, 'rs170', P1, V1, ...);
    %   obj = videoinput('matrox', 1, 'D:\MyCameraFile.dcf', P1, V1, ...);
    if nargin>3,
        PVpairs = varargin(4:end); 
    end
end

% Get the name of the schema for this type of object.
schemaName = imaqmex('getParentSchemaName', adaptorName, deviceID, formatType);

% Create the new UDD and MATLAB OOPs object.
try
    % If a registered schema does not exist, we need to define it.
    if isempty(schemaName),
        % Find the engine XML file.
        engXML = which('imaqmex.imdf', '-all');
        
        % Register the schema definitions.
        imaqmex('registerSchemas', adaptorName, deviceID, formatType, xmlPath, engXML{1});
        schemaName = imaqmex('getParentSchemaName', adaptorName, deviceID, formatType);
    end

    % Construct the parent UDD object.
    pack = findpackage('imaq');
    uddParent = eval(['imaq.', schemaName, '(adaptorName, deviceID, formatType);']);
    connect(uddParent, pack.DefaultDatabase, 'up');
    
    % Construct a UDD object for each device source.
    nSrcs = uddParent.getnumberofdevicesources;
    uddchildren = [];
    for s = 1:nSrcs,
        uddchildren = [uddchildren eval(['imaq.' schemaName, '_source(uddParent)'])];
    end
    
    % Cast the UDD children to an OOPs object.
    oopsChild = videosource(uddchildren);
    
    % Finish building the parent OOPs.
    obj.uddobject = uddParent;
    obj = class(obj, className, parent);
    
    % Link the parent to its children and adaptor.
    uddParent.addchildren(uddchildren, obj, oopsChild);
    try
        uddParent.linktoadaptor;
    catch
        delete(uddParent);
        rethrow(lasterror);
    end

    % Store the constructor arguments. These are needed to save and load.
    % TODO: this property should not be accesible via OOPs.
    p = schema.prop(obj.uddobject, 'ObjectConstructorArguments', 'MATLAB array');
    obj.uddobject.ObjectConstructorArguments = varargin;
    p.AccessFlags.PublicSet = 'off';
    p.Visible = 'off';
    p = schema.prop(obj.uddobject, 'ObjectGUID', 'int32');
    obj.uddobject.ObjectGUID = int32(fix(rand * 2^31));
    p.Visible = 'off';
catch
    rethrow(lasterror);
end
  
% Assign the properties.
if ~isempty(PVpairs)
   try
      set(obj, PVpairs{:});
   catch
      delete(obj); 
      rethrow(lasterror);
   end
end   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [newDeviceFile, fileFlag] = localAddPathToFile(deviceFile)
% Adds the path to the device file if none are present.
% Also returns a flag indicating if the format looks 
% like a device file.

% Initilaize.
fileFlag = true;
newDeviceFile = deviceFile;

% Check to see if a path was already present, because if 
% it was, there's nothing more for us to do.
[pathStr, fileName, fileExt] = fileparts(deviceFile);
if isempty(pathStr),
    % If no file extension was provided either, 
    % must assume it's not a device file.
    if isempty(fileExt)
        fileFlag = false;
    end
    
    % Try to add a path and extension (via WHICH). If file is
    % '-', WHICH errors. If the file is a MATLAB operator, WHICH
    % returns a path, so we need to check for that.
    try
        pathLocation = which(deviceFile);
        if ~isempty(findstr(pathLocation, fullfile('matlab', 'ops'))),
            pathLocation = '';
        end
    catch
        pathLocation = '';
    end
    
    if ~isempty(pathLocation),
        newDeviceFile = pathLocation;
        fileFlag = true;
    end
end
