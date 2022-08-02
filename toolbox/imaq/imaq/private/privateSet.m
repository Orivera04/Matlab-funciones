function [output, errStruct] = privateSet(obj, varargin, nIn, nOut)
%PRIVATESET Configure or display image acquisition object properties.
%
%    [OUT, ERRSTRUCT] = PRIVATESET(OBJ, VARARGIN, NIN, NOUT) performs the
%    SET implemention for image acquisition toolbox objects. OBJ is the
%    image acquisition object, VARARGIN is the input to SET, and NIN and NOUT 
%    are the number of input and output arguments provided to SET. OUTPUT
%    is the SET result, and ERRSTRUCT is the error structure conatining any
%    error identifiers and messages.
%

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:16 $

% Initialize return arguments.
output = [];
errStruct.identifier = '';
errStruct.message = '';

% Call builtin set if OBJ isn't an image acquisition object.
% Ex. set(gcf, obj);
% Ex. set(obj, 'FramesPerTrigger', obj);
if ~( isa(obj, 'imaqchild') || isa(obj, 'imaqdevice') ),
    try
        builtin('set', obj, varargin{:});
    catch
        errStruct = lasterror;
    end
    return;
end

% Error if invalid.
if ~all(isvalid(obj)),
    errStruct.identifier = 'imaq:set:invalidOBJ';
    errStruct.message = privateMsgLookup(errStruct.identifier);
    return;
end

% Extract UDD object.
uddobj = privateGetField(obj, 'uddobject');

% Construct appropriate displays and calls.
if nOut == 0,
    if nIn == 1,
        % Ex. set(obj)
        if (length(obj) > 1),
            errStruct.identifier = 'imaq:set:vectorOBJ';
            errStruct.message = privateMsgLookup(errStruct.identifier);
        else
            localSetListDisp(uddobj);
        end
    else
        % Ex. set(obj, 'FramesPerTrigger');
        % Ex. set(obj, 'FramesPerTrigger', 48);
        try
            % Call the UDD set method.
            if (nIn == 2)
                if ischar(varargin{1}) 
                    % Ex. set(obj, 'LoggingMode')
                    % Obtain the property's enums (this also
                    % ensures we have a valid property).
                    enums = set(uddobj, varargin{1});
                    
                    % Correct the case of the property name - i.e case
                    % insensitivity.
                    handle = uddobj.classhandle;
                    propinfo = findprop(handle, varargin{1});
                    
                    % Create the property's enum display.
                    fprintf('%s\n', privateCreatePropEnumDisp(propinfo.Name, enums, propinfo.DefaultValue));
                else
                    % Ex. set(obj, struct);
                    builtin('set', uddobj, varargin{:});
                end
            else
                % Ex. set(obj, 'FramesPerTrigger', 48, ...); 
                % Ex. set(obj, {'FramesPerTrigger', 'Timeout', 'LoggingMode'}, {48, 5, 'disk'}); 
                builtin('set', uddobj, varargin{:});
            end
        catch
            privateFixUDDError;
            errStruct = lasterror;
        end	
    end
elseif ((nOut == 1) && (nIn == 1))
    % Ex. out = set(obj);
    try
        % Call the UDD SET method and sort the list.
        outputStruct = set(uddobj);
        fields = fieldnames(outputStruct);
        % Use LOWER to ensure properties are alphabetized:
        % Logging, then LogToDiskMode, not the other way around.
        [sorted, ind] = sort(lower(fields));
        for i=1:length(sorted),
            output.( fields{ind(i)} ) = outputStruct.( fields{ind(i)} );
        end
    catch
        errStruct = lasterror;
    end
else
    % Ex. out = set(obj);
    % Ex. out = set(obj, 'FramesPerTrigger')
    % Ex. out = set(obj, 'FramesPerTrigger', 48)
    try
        % Call the UDD set method.
        output = builtin('set', uddobj, varargin{:});
        if nIn>2,
            % Handles the case where we have:
            %   >> out = set(ch(1), {'Selected'}, {'foobar'})
            %
            % This syntax executes the set correctly, but "out" remains
            % unassigned. I.e. it'll perform the set and return:
            %    ??? Error using ==> set
            %    One or more output arguments not assigned during call to 'imaqchild/set'.
            %
            % In order for FEVAL to work properly, we *need* to return
            % something for "output".
            output = [];
        end
    catch
        privateFixUDDError;
        errStruct = lasterror;
    end	
end	

% *******************************************************************
function localSetListDisp(uddobj)
% Create the SET display for SET(OBJ).

% TODO: Re-sort vendor specific properties.
% Create a sorted list of PV pairs.
list = set(uddobj);
handle = uddobj.classhandle;
listValues = struct2cell(list);
propertyNames = fieldnames(list);

% Use LOWER to ensure proeprties are alphabetized:
% Logging, then LogToDiskMode, not the other way around.
[sortedNames index] = sort(lower(propertyNames));

% Initialize different property grouping containers.
srcRelated = '';
callbackRelated = '';
triggerRelated = '';
genRelated = '';
deviceSpecific = '';

% Display each property as follows:
%   ...
%   LoggingMode: [ append | index | {overwrite} ]
%   Name
%   ...
indent = blanks(4);
strToDisp = '';
for i=1:length(sortedNames),
    property = propertyNames{index(i)};
    enumStr = '';
    propName = sprintf([indent property]);
    propertyinfo = findprop(handle, property);
    
    % Create the enum value line
    if ~isempty(listValues{index(i)}) || ~isempty(findstr('Fcn ', [propName ' '])),
        enumDisp = privateCreatePropEnumDisp(property, listValues{index(i)}, propertyinfo.DefaultValue);
        enumStr = sprintf(': %s', enumDisp);
    end
    strToDisp = sprintf('%s%s\n', propName, enumStr);
    
    % Determine how to categorize the property.
    switch propertyinfo.Category,
        case 'acqSrc',
            srcRelated = [srcRelated strToDisp];
        case 'callback',
            callbackRelated = [callbackRelated strToDisp];
        case 'trigger',
            triggerRelated = [triggerRelated strToDisp];
        otherwise,
            if propertyinfo.DeviceSpecific
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
