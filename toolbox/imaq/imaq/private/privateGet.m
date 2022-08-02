function [output, errStruct] = privateGet(obj, varargin, nIn, nOut)
%PRIVATEGET Get image acquisition object properties..
%
%    [OUT, ERRSTRUCT] = PRIVATEGET(OBJ, VARARGIN, NIN, NOUT) performs the
%    GET implemention for image acquisition toolbox objects. OBJ is the
%    image acquisition object, VARARGIN is the input to GET, and NIN and NOUT 
%    are the number of input and output arguments provided to GET. OUTPUT
%    is the GET result, and ERRSTRUCT is the error structure conatining any
%    error identifiers and messages.
%

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:13 $

% Initialize return arguments.
output = [];
errStruct.identifier = '';
errStruct.message = '';

% Call builtin get if OBJ isn't an image acquisition object.
% Ex. get(gcf, obj);
if ~( isa(obj, 'imaqchild') || isa(obj, 'imaqdevice') )
    try
        builtin('get', obj, varargin{:});
    catch
        errStruct = lasterror;
    end
    return;
end

% Perform some error checking.
if nIn>2,
    errStruct.identifier = 'imaq:get:tooManyInputs';
    errStruct.message = privateMsgLookup(errStruct.identifier);
    return;
elseif ~all(isvalid(obj)),
    errStruct.identifier = 'imaq:get:invalidOBJ';
    errStruct.message = privateMsgLookup(errStruct.identifier);
    return;
end

% Extract UDD object.
uddobj = privateGetField(obj, 'uddobject');

if ((nOut == 0) && (nIn == 1))
    % Ex. get(obj)
    if (length(obj) > 1),
        errStruct.identifier = 'imaq:get:vectorOBJ';
        errStruct.message = privateMsgLookup(errStruct.identifier);
    else
        localCreateGetDisplay(uddobj);
    end
elseif ((nOut == 1) && (nIn == 1))
    % Ex. out = get(obj);
    try
        % Call the UDD GET method and sort the list.
        oldfields = {};
        for nthStruct = 1:length(uddobj),
            getStruct = get(uddobj(nthStruct));
            fields = fieldnames(getStruct);
            
            % Make sure that all of the objects have the same properties.
            % This is currently always the case because it is not possible
            % to concatentate objects with different properties, but check
            % to be safe.
            if ~isempty(oldfields)
                if ~isempty(setxor(oldfields, fields))
                    errStruct.identifier = 'imaq:get:sameprops';
                    errStruct.message = privateMsgLookup(errStruct.identifier);
                    return;
                end
            else
                oldfields = fields;
            end
                    
            % Use LOWER to ensure proeprties are alphabetized:
            % Logging, then LogToDiskMode, not the other way around.
            [sorted, ind] = sort(lower(fields));
            for i=1:length(sorted),
                output(nthStruct, 1).( fields{ind(i)} ) = getStruct.( fields{ind(i)} );
            end
        end
    catch
        privateFixUDDError;
        errStruct = lasterror;
    end
else
    % Ex. get(obj, 'Name')
    try
        % Capture the output - call the UDD get method.
        output = get(uddobj, varargin{:});
    catch
        privateFixUDDError;
        errStruct = lasterror;
    end	
end

% ***************************************************************
% Create the GET display.
function localCreateGetDisplay(uddobj)

% TODO: Re-sort vendor specific properties.
% Create a sorted list of PV pairs.
getStruct = get(uddobj);
listValues = struct2cell(getStruct);
propertyNames = fieldnames(getStruct);

% Use LOWER to ensure proeprties are alphabetized:
% Logging, then LogToDiskMode, not the other way around.
[sortedNames index] = sort(lower(propertyNames));

% Capture UDD's GET structure display.
% This provides us with a formated display of a property's value.
uddGetDisp = evalc('disp(getStruct)');
CRind = findstr(uddGetDisp, sprintf('\n'));

% Initialize different property grouping containers.
srcRelated = '';
callbackRelated = '';
triggerRelated = '';
genRelated = '';
deviceSpecific = '';

for i=1:length(sortedNames),
    % Using the sorted property list, extract the property 
    % name and its actual value.
    property = propertyNames{index(i)};
    value = listValues{index(i)};
    
    % For strings, display the value to avoid having extra quotes.
    % For all other types, use the formated value display from 
    % the GET structure display. 
    cr = sprintf('\n');
    if ~ischar(value)
        % No CR for non-chars
        cr = '';
        
        % Locate the start and end of the property's value in 
        % the GET structure display.
        startind = findstr(uddGetDisp, [' ' property ':']) + length(property) + 3;
        CRlist = find((CRind > startind)==1);
        
        % Extract the property's value from the GET structure display.
        value = uddGetDisp(startind:CRind(CRlist(1)));
    end

    % Create the PV line.
    strToDisp = [sprintf('    %s = %s', property, value), cr];
    
    % Determine how to categorize the property.
    propertyInfo = findprop(uddobj, property);
    switch propertyInfo.Category,
        case 'acqSrc',
            srcRelated = [srcRelated strToDisp];
        case 'callback',
            callbackRelated = [callbackRelated strToDisp];
        case 'trigger',
            triggerRelated = [triggerRelated strToDisp];
        otherwise,
            if propertyInfo.DeviceSpecific
                deviceSpecific = [deviceSpecific strToDisp];
            else
                genRelated = [genRelated strToDisp];
            end
    end    
end

% Display properties in groups.
%
% Note: CR is needed in order to get proper spaces
%       in codepad demos.
cr = sprintf('\n');
fprintf('  General Settings:%s%s%s', cr, genRelated, cr);

if ~isempty(callbackRelated)
    fprintf('  Callback Function Settings:%s%s%s', cr, callbackRelated, cr);
end

if ~isempty(triggerRelated)
    fprintf('  Trigger Settings:%s%s%s', cr, triggerRelated, cr);
end

if ~isempty(srcRelated)
    fprintf('  Acquisition Sources:%s%s%s', cr, srcRelated, cr);
end

if ~isempty(deviceSpecific)
    fprintf('  Device Specific Properties:%s%s%s', cr, deviceSpecific, cr);
end
