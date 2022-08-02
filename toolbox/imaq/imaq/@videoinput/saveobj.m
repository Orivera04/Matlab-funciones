function out = saveobj(obj)
%SAVEOBJ Save filter for objects.
%
%    B = SAVEOBJ(OBJ) is called by SAVE when an object is
%    saved to a .MAT file. The return value B is subsequently used by
%    SAVE to populate the .MAT file.  
%
%    SAVEOBJ will be separately invoked for each object to be saved.
% 
%    See also IMAQ/PRIVATE/SAVE.
%

%    CP 9-3-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:43 $

% Define a persistent variable to help with recursively linked objects.
persistent objsSaved;

% Check to see if we have previously saved this object prior.
if ~isempty(objsSaved)
    for i = 1:length(objsSaved)
        if isequal(objsSaved{i}, obj)
            % Detected that object has been previously saved
            % Break the recursive link.
            out = [];
            
            % Store the state of the warning. Turn off backtrace.
            warnstate = warning('off', 'backtrace'); 
            warning(imaqgate('privateMsgLookup', 'imaq:saveobj:recursive'));
            warning(warnstate); 
            return;
        end
    end
end

% Object was not saved prior, add to recursive list.
objsSaved{end+1} = obj;

% Determine the number of objects being saved.
allUDObjects = imaqgate('privateGetField', obj, 'uddobject');
numUDObjects = length(allUDObjects);

% ***************************************************************************
% A structure will be created which contains:
% x(i).uddobject = uddobject
% x(i).props    = get(uddobject) % Read-only properties removed (except Type).
% x(i).childprops = get(child object) % Read-only properties removed (except Type).
% x(i).location = locations of the object.
%
% The location of the object is represented as a cell of structs. The 
% structures contain the following information.
%
%  Ex. y(1).Temp = 4; y(2).Temp = s1; s.UserData = y;    
%      s1's location field contains:
%           x.ObjectIndex = 1;             % s is stored in x(1)
%           x.Property    = 'UserData';
%           x.Index       = {'()', 2, '.', 'Temp', '()', 1};
%
% Every uddobject will be replaced with the index of the appropriate uddobject
% in the x structure.
% ***************************************************************************

% Create an empty structure which contains the necessary information to 
% recreate all the objects.
%
% Note: '' is used for all fields in order to have the variable initialized
% to a 1x1 struct, not a 0x0.
propInfo = struct('uddobject', '', 'props', '', 'childprops', '', 'location', '');

% Create a cell which will contain the index into the object array stored in the propInfo  
% structure.
indexToObj = cell(1, numUDObjects);

% Loop through each object and save.
for i = 1:numUDObjects
    currentObj = allUDObjects(i);
    
    % Determine the current index into the propInfo structure.
    if isempty(propInfo(1).uddobject)
        index = 1;
    else
        index = length(propInfo) + 1;
    end
    
    % Determine if the object has already been saved.
    if localIsSaved(currentObj)
        % Object has been saved. Determine which object currentObj is equal to.
        indexToObj{i} = localFindSavedObject(currentObj, propInfo);
        
    elseif ishandle(currentObj)
        % If the object is valid get it's property values.
        propInfo = localCacheProps(currentObj, propInfo, index, index);
        
        % Store the location in the indexToObj array.
        indexToObj{i} = index;
        
        % Parse the object to determine if the UserData or the Fcn
        % properties contain any image acquisition objects.
        propInfo = localParsePropsForObjects(currentObj, propInfo);
        
    else
        if ~localIsInvalidHandleSaved(currentObj),
            % Set the warning to not use a backtrace.
            warnstate = warning('off', 'backtrace');
            warning(imaqgate('privateMsgLookup', 'imaq:saveobj:invalid'));
            warning(warnstate);
            
            % Cache the invalid handle
            localCacheInvalidHandle(currentObj);
        end
        
        % Invalid object - just save it. 
        % Store the location in the indexToObj arrays.
        propInfo(index).props = currentObj;        
        indexToObj{i} = index;
    end
end

% Create the object that is going to be saved.
savedObj = obj;
savedObj = isetfield(savedObj, 'uddobject', indexToObj);

% Remove the saved field.
localRemoveSavedFlag(propInfo);

% Store the table of objects in the store field - minus the UDD objects.
parentField = imaqgate('privateGetField', obj, 'imaqdevice');
propInfo = rmfield(propInfo, 'uddobject');
parentField = isetfield(parentField, 'store', propInfo);
savedObj = isetfield(savedObj, 'imaqdevice', parentField);

% Define output.
out = savedObj;

% Object saved without recurssive issue, remove from recursive list.      
objsSaved(end) = [];                                                       

% ************************************************************************
function localIndicateSaved(currentObj)
% Indicate that the object has been saved.

if ishandle(currentObj)
    % Add a temporary property called Saved that cannot be accessed through
    % SET or GET.
    p = schema.prop(currentObj, 'Saved', 'double');
    p.AccessFlags.PublicGet = 'off';
    p.AccessFlags.PublicSet = 'off';
end

% ************************************************************************
function localCacheInvalidHandle(currentObj)
% Cache a list of invalid handles that have been saved.
global INVALID_HANDLES_CACHED;

INVALID_HANDLES_CACHED = [INVALID_HANDLES_CACHED; currentObj(:)];

% ************************************************************************
function isSaved = localIsInvalidHandleSaved(currentObj)
% Determine if invalid handle has been saved. Returns a logical 1 if saved,
% otherwise returns a logical 0.
global INVALID_HANDLES_CACHED;

if isempty(INVALID_HANDLES_CACHED),
    isSaved = false;
else
    for i=1:length(currentObj);
        isSaved(i) = any(currentObj(i)==INVALID_HANDLES_CACHED);
    end
    isSaved = all(isSaved);
end
return

% ************************************************************************
function isSaved = localIsSaved(currentObj)
% Determine if object has been saved. Returns a logical 1 if saved,
% otherwise returns a logical 0.

if ishandle(currentObj)
    isSaved = ~isempty(currentObj.findprop('Saved'));
else
    % Invalid object.
    isSaved = false;
end

% ************************************************************************
function localRemoveSavedFlag(propInfo)
% Remove the saved flag.

% Can't use instrfind since invalid objects could have been modified.
for i = 1:length(propInfo)
    currentObj = propInfo(i).uddobject;
    if ~isempty(currentObj) && ishandle(currentObj),
        delete(currentObj.findprop('Saved'));
    end
end

% ****************************************************************************
function equalIndex = localFindSavedObject(currentObj, propInfo)
% Find index of already saved object.

% Loop through and find equivalent object.
equalIndex = 1;
for i = 1:length(propInfo)
    if currentObj == propInfo(i).uddobject,
        equalIndex = i;
        break
    end
end

% ****************************************************************************
function settable = localFindSettableProperties(currentObj)
% Save the settable properties only including the Type property.

% Determine the property values.
allProps = get(currentObj);
propNames = fieldnames(allProps);

% Find the non-settable properties.
nonSettableProps = setdiff(propNames, fieldnames(set(currentObj)));

% Remove the non-settable properties from property structure.
nonSettableProps(find(strcmp('Type', nonSettableProps))) = [];
settable = rmfield(allProps, nonSettableProps);

% Store the constructor arguments if any are available.
% TODO: Provide a UDD method that returns the constructor arguments
% if available.
try
    settable.ConstructorArgs = currentObj.ObjectConstructorArguments;
catch
    settable.ConstructorArgs = [];
end

% Store the object ID if it is available.
% TODO: Provide a UDD method that returns the ID
% if available.
try
    settable.ObjectGUID = currentObj.ObjectGUID;
catch
    settable.ObjectGUID = [];
end

% ****************************************************************************
function parseProps = localGetPropsToSearch(currentObj, allProps)
% Determine which properties need to be parsed for a possible object.

% Get a list of all properties and determine which may
% contain an object embedded inside it.
count = 1;
propNames = fieldnames(allProps);
for i = 1:length(propNames),
    try
        pi = propinfo(currentObj, propNames{i});
        switch pi.Type
            case {'callback', 'any'},
                parseProps{count} = propNames{i};
                count = count+1;
        end
    catch
    end
end

% ****************************************************************************
function propInfo = localParsePropsForObjects(currentObj, propInfo)
% Parse the properties that may contain additional objects.

% Determine if we're dealing with a parent or child object.
% Child objects can not contain other objects.
if ~isempty(findprop(currentObj, 'Parent'))
    return;
end

% Initialize variables.
index = length(propInfo);
allProps = propInfo(index).props;

% Find the parseable properties, like Fcn properties and UserData.
parseProps = localGetPropsToSearch(currentObj, allProps);

% Loop through each property and determine if the property value contains
% an object.
for i = 1:length(parseProps)
    propValue = allProps.(parseProps{i});
    
    switch class(propValue)
        case {'videosource'}
            % One or more child objects. Concatenated child objects will have
            % the same parent.
            currentArray = imaqgate('privateGetField', propValue, 'uddobject');
            
            % Determine the parent's child index we are dealing with.
            % Then store the child's parent info, and indicate the index into 
            % it's child vector.
            if ~all(ishandle(currentArray))
                if ~localIsInvalidHandleSaved(currentArray),
                    % Set the warning to not use a backtrace.
                    warnstate = warning('off', 'backtrace');
                    warning(imaqgate('privateMsgLookup', 'imaq:saveobj:invalid'));
                    warning(warnstate);
                    
                    % Cache the invalid handle
                    localCacheInvalidHandle(currentArray);
                end
            
                % Invalid object - just save it. 
                %
                % Note: Since we extracted the UDD object out, we need to
                % make sure that when we're saving invalid objects, that we
                % wrap the UDD object back into an OOPs object. Otherwise on
                % loading, we'll get a handle object back, not one of our
                % objects.
                savedIndex = length(propInfo);
                propInfo(savedIndex+1).props = videosource(currentArray);
                
                % Add the object to the location cell.
                propInfo = localAddArrayLocation(propInfo, savedIndex+1, parseProps{i}, index, 1, []);
            else
                for j = 1:length(currentArray)
                    [parentUDObj, childIndex] = localGetChildIndex(currentArray(j));
                    propInfo = localSaveObject(parentUDObj, propInfo, parseProps{i}, index, j, childIndex);
                end
            end
            
        case {'imaqdevice', 'videoinput'}
            % One or more parent objects.
            currentArray = imaqgate('privateGetField', propValue, 'uddobject');
            for j = 1:length(currentArray)
                propInfo = localSaveObject(currentArray(j), propInfo, parseProps{i}, index, j, []);        
            end
            
        case 'struct'
            % Loop through each field and determine if the field contains an image acquisition
            % object.
            propInfo = localSaveStruct(propInfo, parseProps{i}, index, propValue, {});
            
        case 'cell'
            % Loop through each element of the cell array and determine if the cell
            % array element contains an image acquisition object.
            propInfo = localSaveCell(propInfo, parseProps{i}, index, propValue, {});
            
        otherwise
            if isobject(propValue)
                propInfo = localSaveOtherObject(propValue, propInfo, parseProps{i}, index, {});
            end
    end
end

% ****************************************************************************
function propInfo = localSaveOtherObject(currentObj, propInfo, prop, objectIndex, index)
% Save someone elses object.

propInfo(end+1).uddobject = [];
try
    propInfo(end).props = saveobj(currentObj);
catch
    propInfo(end).props = currentObj;
end
savedIndex = length(propInfo);

% Remove the image acquisition object and add to the location cell.
propInfo = localAddArrayLocation(propInfo, savedIndex, prop, objectIndex, index, []);

% ****************************************************************************
function propInfo = localCacheProps(currentObj, propInfo, indexForObj, indexForProps)
% Store the parent and child property values.

propInfo(indexForObj).uddobject = currentObj;
propInfo(indexForProps).props = localFindSettableProperties(currentObj);

% Store the property values for all its children.
children = get(currentObj, 'Source');
nChildren = length(children);
for nChild = 1:nChildren,
    propInfo(indexForProps).childprops{nChild} = localFindSettableProperties( children(nChild) );
end

% Indicate that the object has been saved.
localIndicateSaved(currentObj);

% ****************************************************************************
function [parentUDObj, childIndex] = localGetChildIndex(childObj)
% Given a child object, return its parent and its location in the parent's child 
% vector.

% Determine the parent and child UDD objects.
parentUDObj = imaqgate('privateGetField',  get(childObj, 'Parent') , 'uddobject');
children = imaqgate('privateGetField',  get(parentUDObj, 'Source') , 'uddobject');

% Determine the parent's child index we are dealing with.
childIndex = find(childObj==children);

% ****************************************************************************
function propInfo = localSaveObject(currentObj, propInfo, prop, objectIndex, index, childIndex)
% Save information on our objects. If CHILDINDEX is non-empty, the parent's child at
% the specified CHILDINDEX is the object we will want to save.

% Determine if the object has already been saved.
if localIsSaved(currentObj)
    % Object has been saved. Determine which object currentObj is equal to.
    savedIndex = localFindSavedObject(currentObj, propInfo);
    
    % Remove the image acquisition object and add to the location cell.
    propInfo = localAddArrayLocation(propInfo, savedIndex, prop, objectIndex, index, childIndex);
    propInfo = localRemoveUDDFromProperty(propInfo, index, objectIndex, prop);
    
elseif ishandle(currentObj)
    % If the object is valid store the property values.
    savedIndex = length(propInfo);
    propInfo = localCacheProps(currentObj, propInfo, savedIndex+1, savedIndex+1);
    
    % Remove the image acquisition object and add to the location cell.
    propInfo = localAddArrayLocation(propInfo, savedIndex+1, prop, objectIndex, index, childIndex);
    propInfo = localRemoveUDDFromProperty(propInfo, index, objectIndex, prop);
    
    % Parse the object to determine if the UserData or the Fcn
    % properties contain any image acquisition objects.
    propInfo = localParsePropsForObjects(currentObj, propInfo);
    
else
    if ~localIsInvalidHandleSaved(currentObj),
        % Set the warning to not use a backtrace.
        warnstate = warning('off', 'backtrace');
        warning(imaqgate('privateMsgLookup', 'imaq:saveobj:invalid'));
        warning(warnstate);
       
        % Cache the invalid handle
        localCacheInvalidHandle(currentObj);
    end
    
    % Invalid object - just save it. 
    %
    % Note: Since we extracted the UDD object out, we need to
    % make sure that when we're saving invalid objects, that we
    % wrap the UDD object back into an OOPs object. Otherwise on
    % loading, we'll get a handle object back, not one of our
    % objects.
    savedIndex = length(propInfo);
    propInfo(savedIndex+1).props = videoinput(currentObj);
    
    % Add the object to the location cell.
    propInfo = localAddArrayLocation(propInfo, savedIndex+1, prop, objectIndex, index, []);
end

% ****************************************************************************
function propInfo = localSaveStruct(propInfo, prop, objectIndex, propValue, index)
% Save a structure which may or may not contain our objects.

% Get the fields of the property Value.
names = fieldnames(propValue);

% Loop through each field value and determine if it is set to a cell, struct or
% an image acquisition object.
for j = 1:length(propValue)
    for i = 1:length(names)
        value = propValue(j).(names{i});
        if isstruct(value)
            index = localUpdateIndex('struct', index, {'()' j, '.', names{i}});
            propInfo = localSaveStruct(propInfo, prop, objectIndex, value, index);
            index = index(1:end-4);
            
        elseif iscell(value)
            index = localUpdateIndex('struct', index, {'()' j, '.', names{i}});
            propInfo = localSaveCell(propInfo, prop, objectIndex, value, index);
            index = index(1:end-4);
            
        elseif isa(value, 'imaqdevice')
            % Done - found imaq parent object. 
            index = localUpdateIndex('struct', index, {'()' j, '.', names{i}});
            [index, propInfo] = localSaveEmbeddedParent(index, value, propInfo, prop, objectIndex);
            index = index(1:end-4);
            
        elseif isa(value, 'imaqchild')
            % Done - found imaq child object. 
            index = localUpdateIndex('struct', index, {'()' j, '.', names{i}});
            [index, propInfo] = localSaveEmbeddedChild(index, value, propInfo, prop, objectIndex);
            index = index(1:end-4);
            
        elseif isobject(value)
            % Handle all other objects by using their SAVEOBJ method.
            index = localUpdateIndex('struct', index, {'()' j, '.', names{i}});
            propInfo = localSaveOtherObject(value, propInfo, prop, objectIndex, index);
            index = index(1:end-4);
        end
    end
end

% ****************************************************************************
function propInfo = localSaveCell(propInfo, prop, objectIndex, propValue, index)
% Save a structure which may or may not contain our objects.

% Loop through each cell and determine if it is set to a cell, struct or
% an image acquisition object.
for j = 1:numel(propValue)
    value = propValue{j};
    if isstruct(value)
        index = localUpdateIndex('cell', index, {'{}', j});
        propInfo = localSaveStruct(propInfo, prop, objectIndex, value, index);
        index = index(1:end-2);
        
    elseif iscell(value)
        index = localUpdateIndex('cell', index, {'{}', j});
        propInfo = localSaveCell(propInfo, prop, objectIndex, value, index);
        index = index(1:end-2);
        
    elseif isa(value, 'imaqdevice')
        % Done - found imaq parent object. 
        index = localUpdateIndex('cell', index, {'{}', j});
        [index, propInfo] = localSaveEmbeddedParent(index, value, propInfo, prop, objectIndex);
        index = index(1:end-2);
        
    elseif isa(value, 'imaqchild')
        % Done - found imaq child object. 
        index = localUpdateIndex('cell', index, {'{}', j});
        [index, propInfo] = localSaveEmbeddedChild(index, value, propInfo, prop, objectIndex);
        index = index(1:end-2);
        
    elseif isobject(value)
        % Handle all other objects by using their SAVEOBJ method.
        index = localUpdateIndex('cell', index, {'{}', j});
        propInfo = localSaveOtherObject(value, propInfo, prop, objectIndex, index);
        index = index(1:end-2);
    end
end

% ****************************************************************************
function index = localUpdateIndex(type, index, value)
% Update indices.

% Can't use END on any empty matrix.
switch (type)
    case 'struct'
        if (isempty(index))
            index(1:4) = value;
        else
            index(end+1:end+4) = value;
        end
    case 'cell'
        if (isempty(index))
            index(1:2) = value;
        else
            index(end+1:end+2) = value;
        end
end

% ****************************************************************************
function [index, propInfo] = localSaveEmbeddedParent(index, value, propInfo, prop, objectIndex)
% Save a parent object that was embedded inside a cell or structure.

currentObj = imaqgate('privateGetField', value, 'uddobject');
for k = 1:length(currentObj)
    index(end+1:end+2) = {'()', k};
    propInfo = localSaveObject(currentObj(k), propInfo, prop, objectIndex, index, []);
    index = index(1:end-2);
end

% ****************************************************************************
function [index, propInfo] = localSaveEmbeddedChild(index, value, propInfo, prop, objectIndex)
% Save a child object that was embedded inside a cell or structure.

% Since all child objects must have the same parent, we know that if one is
% invalid, then all children in the array will be invlaid
currentObj = imaqgate('privateGetField', value, 'uddobject');
if ~all(ishandle(currentObj))
    if ~localIsInvalidHandleSaved(currentObj),
        % Set the warning to not use a backtrace.
        warnstate = warning('off', 'backtrace');
        warning(imaqgate('privateMsgLookup', 'imaq:saveobj:invalid'));
        warning(warnstate);
        
        % Cache the invalid handle
        localCacheInvalidHandle(currentObj);
    end
    
    % Invalid object - just save it. 
    %
    % Note: Since we extracted the UDD object out, we need to
    % make sure that when we're saving invalid objects, that we
    % wrap the UDD object back into an OOPs object. Otherwise on
    % loading, we'll get a handle object back, not one of our
    % objects.
    savedIndex = length(propInfo);
    propInfo(savedIndex+1).props = videosource(currentObj);
    
    % Add the object to the location cell.
    index(end+1:end+2) = {'()', 1};
    propInfo = localAddArrayLocation(propInfo, savedIndex+1, prop, objectIndex, index, []);
    index = index(1:end-2);
else
    for k = 1:length(currentObj)
        index(end+1:end+2) = {'()', k};
        [parentUDObj, childIndex] = localGetChildIndex(currentObj(k));
        propInfo = localSaveObject(parentUDObj, propInfo, prop, objectIndex, index, childIndex);
        index = index(1:end-2);
    end
end

% ****************************************************************************
% Add an array location.
function propInfo = localAddArrayLocation(propInfo, savedIndex, prop, objectIndex, arrayIndex, childIndex)

%  Ex. y(1).Temp = 4; y(2).Temp = s1; s.UserData = y;    
%      s1's location field contains:
%           x.ObjectIndex = 1;             % s is stored in x(1)
%           x.Property    = 'UserData';
%           x.Index       = {'()', 2, '.', 'Temp', '()', 1};
%           x.ChildIndex  = {[]};  % [] if no child objects need to be
%                                  % extracted.

% Get the current location field value.
allLocations = propInfo(savedIndex).location;

% Create the structure to be stored.
temp.ObjectIndex = objectIndex;
temp.Property = prop;
temp.Index = arrayIndex;
temp.ChildIndex = childIndex;

% Add the structure to the propInfo array - Can't use END on an empty value.
count = length(allLocations) + 1;
allLocations{count} = temp; 
propInfo(savedIndex).location = allLocations;

% ****************************************************************************
function propInfo = localRemoveUDDFromProperty(propInfo, index, objectIndex, propName)
% Remove the UDD object from propInfo.

propValue = propInfo(objectIndex).props.(propName);
if isnumeric(index) 
    % index points to an image acquisition object.
    propValue = '';
    propInfo(objectIndex).props.(propName) = propValue;
    return;
end

if length(index) >= 2 && (isnumeric(index{end}) && strcmp(index{end-1}, '()'))
    index = index(1:end-2);
end

% Build up the string to access the UDD object.
stringToAccessUDD = '';
for i = 1:2:length(index)
    currentDelimiter = index{i};
    switch (currentDelimiter)
        case '()'
            stringToAccessUDD = [stringToAccessUDD '(' num2str(index{i+1}) ')'];
        case '{}'
            stringToAccessUDD = [stringToAccessUDD '{' num2str(index{i+1}) '}'];
        case '.'
            stringToAccessUDD = [stringToAccessUDD '.' index{i+1}];
    end
end

% Set the UDD object to empty ''.
eval(['propValue' stringToAccessUDD ' = '''';']);

% Update the propInfo structure to contain property value minus UDD object.
propInfo(objectIndex).props.(propName) = propValue;
