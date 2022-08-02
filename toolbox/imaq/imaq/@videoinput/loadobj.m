function obj = loadobj(B)
%LOADOBJ Load filter for image acquisition objects.
%
%    OBJ = LOADOBJ(B) is called by LOAD when an image acquisition object is 
%    loaded from a .MAT file. The return value, OBJ, is subsequently 
%    used by LOAD to populate the workspace.  
%
%    LOADOBJ will be separately invoked for each object in the .MAT file.
%
%    See also IMAQ/PRIVATE/LOAD.
%

%    CP 8-29-02
%    Copyright 2001-2004 The MathWorks, Inc. 
%    $Revision: 1.1.6.4 $  $Date: 2004/03/24 20:38:19 $

% Need to deal with things in a structure format.
obj = B;
if ~isa(obj, 'struct')
    obj = struct(obj);
end

% Get the object's parent store field. If nothing was stored,
% Just return since it was probably just an invalid object.
% MATLAB handles invalid objects for us.
propInfo = imaqgate('privateGetField', obj.imaqdevice , 'store');
if isempty(propInfo)
    return;
end

%  Re-create the objects.
for i = 1:length(propInfo)
	% Get the property structure.
	propVals = propInfo(i).props; 

    if isstruct(propVals)
        % Re-create the parent object.
        %
        % Note: Invalid objects that were saved while embedded, seem 
        %       to be loaded as structs. Try handling the current item
        %       as a valid object, otherwise, treat it as an invalid
        %       object.
        try
            % The ObjectGUID field was added after v1.1 (R13SP1) so it is
            % not guaranteed to be present.  If it is not, it is not a
            % problem, it just means that we won't be able to find any
            % aliases.
            try
                objectGUID = propVals.ObjectGUID;
                aliases = imaqfind('ObjectGUID', objectGUID);
            catch
                aliases = [];
            end
            
            if ~isempty(aliases)
                tempobj = aliases{1};
                propInfo(i).obj = imaqgate('privateGetField', tempobj, 'uddobject');
                continue;
            end
            
            constructorArgs = propVals.ConstructorArgs;
            tempobj = videoinput(constructorArgs{:});
            propInfo(i).obj = imaqgate('privateGetField', tempobj, 'uddobject');
            
            % Reset the parent properties.
            propVals = rmfield(propVals, {'Type', 'ConstructorArgs'});
            try
                set(propInfo(i).obj, propVals);
            catch
                % In case the object is now pointing to a different device.
                warnstate = warning('off', 'backtrace'); 
                warning(imaqgate('privateMsgLookup', 'imaq:loadobj:noInputRestore'));
                warning(warnstate); 
            end
            
            % Reset the child properties.
            children = get(propInfo(i).obj, 'Source');
            nChildren = length(children);
            if nChildren ~= length(propInfo(i).childprops),
                % In case the object is now pointing to a different device.
                warnstate = warning('off', 'backtrace'); 
                warning(imaqgate('privateMsgLookup', 'imaq:loadobj:wrongDevice'));
                warning(warnstate); 
            else
                for nChild = 1:nChildren,
                    childPropVals = propInfo(i).childprops{nChild};
                    childPropVals = rmfield(childPropVals, {'Type', 'ConstructorArgs'});
                    
                    % The ObjectGUID field is not guaranteed to be present.
                    %  IF it is not, then it doesn't need to be removed.
                    try 
                        childPropVals = rmfield(childPropVals, 'ObjectGUID');
                    catch
                    end
                    
                    try
                        set(children(nChild), childPropVals);
                    catch
                        % In case the object is now pointing to a different device.
                        warnstate = warning('off', 'backtrace'); 
                        warning(imaqgate('privateMsgLookup', 'imaq:loadobj:noSourceRestore'));
                        warning(warnstate); 
                    end
                end
            end
            
        catch
            % Invalid object.
            propInfo(i).obj = videoinput(propVals);
        end
    else
        % Invalid object.
		propInfo(i).obj = propVals;
    end
end

% Parse through each object's embeddable property to determine
% if the values contained an object.
localRestoreEmbeddableProps(propInfo);

% Recreate our OOPs object with the correct UDD objects.
uddObjects = obj.uddobject;
for i = 1:length(uddObjects);
    out(i) = propInfo(uddObjects{i}).obj;
end
tempObj = videoinput(out);

% Configure the type field to have the correct length.
obj = isetfield(tempObj, 'type', obj.type);

% **************************************************************************
function localRestoreEmbeddableProps(propInfo)
% Restore all embeddable properties.

for i = 1:length(propInfo)
    % Get the current location of the object.
    currentObj = propInfo(i).obj;
    allLocations = propInfo(i).location;
    
    % Check to see if we're dealing with one of our objects.
    isimaqobj = true;
    className = class(currentObj);
    if isempty(findstr('imaq.', className))
        isimaqobj = false;
    end
    
    % Loop through each location, restore the object, and wrap UDD
    % object into a OOPs object.
    for j = 1:length(allLocations)
        loc = allLocations{j};
        objectToSet = propInfo(loc.ObjectIndex).obj;
        currentPropValue = get(objectToSet, loc.Property);
        
        % Determine what kind of object was embedded upon saving.
        if isimaqobj,
            if ~isempty(loc.ChildIndex)
                % Need to insert a parent's child.
                children = get(currentObj, 'Source');
                objToInsert = children(loc.ChildIndex);
            else
                % Need to insert the parent.
                objToInsert = videoinput(currentObj);
            end
        else
            % Need to insert whatever the object was.
            objToInsert = currentObj;
        end

        if isnumeric(loc.Index)
            % Contains a direct image acquisition object. Ex. s.UserData = s;
            currentPropValue = localFillInArray(currentPropValue, objToInsert, loc.Index);
        else
            % Image acquisition object is within a structure or a cell.
            if (length(loc.Index) > 2) && (isnumeric(loc.Index{end}) && strcmp(loc.Index{end-1}, '()'))
                currentPropValue = localFillInStructOrCellWithArray(currentPropValue, objToInsert, loc.Index);
            else
            	currentPropValue = localFillInStructOrCell(currentPropValue, objToInsert, loc.Index);
            end
        end
        
        % Update the propInfo structure's object to contain a new value for the embeddable property.
        eval(['propInfo(' num2str(loc.ObjectIndex) ').obj.' loc.Property ' =  currentPropValue;'])
    end    
end

% ****************************************************************************
function currentPropValue = localFillInStructOrCell(currentPropValue, obj, index)
% Fill in the array according to the index value.

% Build up the string to access the UDD object.
stringToAccessUDD = '';
for i = 1:2:length(index)
    stringToAccessUDD = localAppendIndexingString(stringToAccessUDD, index, i);
end

% Set the property to the object.
eval(['currentPropValue' stringToAccessUDD ' = obj;']);

% ****************************************************************************
function currentPropValue = localFillInStructOrCellWithArray(currentPropValue, obj, index)
% Fill in the array according to the index value.

% Build up the string to access the UDD object.
stringToAccessUDD = '';
for i = 1:2:length(index)-2,
    stringToAccessUDD = localAppendIndexingString(stringToAccessUDD, index, i);
end

% Set the property to the object.
if ~isempty(currentPropValue)
	val = eval(['currentPropValue' stringToAccessUDD ';']);
	val = localFillInArray(val, obj, index{end});
else
    val = localFillInArray('', obj, index{end});
end
eval(['currentPropValue' stringToAccessUDD ' = val;']);

% ****************************************************************************
function stringToAccessUDD = localAppendIndexingString(stringToAccessUDD, index, i)
% Append the appropriate indexing string.

currentDelimiter = index{i};
switch (currentDelimiter)
    case '()'
        stringToAccessUDD = [stringToAccessUDD '(' num2str(index{i+1}) ')'];
    case '{}'
        stringToAccessUDD = [stringToAccessUDD '{' num2str(index{i+1}) '}'];
    case '.'
        stringToAccessUDD = [stringToAccessUDD '.' index{i+1}];
end

% ****************************************************************************
function currentPropValue = localFillInArray(currentPropValue, obj, index)
% Fill in the array according to the index value.

% If there is no current propety value, we will need to indiacte that the
% property value to fill lives within the current object.
len = length(currentPropValue);
if len == 0
    len = 1;
end

if index <= len
    % Index in and replace a property value element with the object.
    if len == 1
        % Need to replace a vlaue within the current object. 
        currentPropValue = obj;
    end
    currentPropValue = localReplaceElement(currentPropValue, {index}, obj);
else
    % Need to fill in something - Just use the object.
    for i = len:index-1
        currentPropValue = [currentPropValue obj];
    end
end

% *********************************************************************
function [obj, errflag] = localReplaceElement(obj, index, Value)
% Replace the specified element.

% Initialize variables.
errflag = 0;
try
   % Get the current state of the object.
   uddObject = imaqgate('privateGetField', obj, 'uddobject');
   type = imaqgate('privateGetField', obj, 'type');
   
   % Make sure we have a cell.
   if ~iscell(type)
      type = {type};
   end
   
   % Replace the specified index with Value.
   if ~isempty(Value)
       if ((length([index{1}]) > 1) && (length(Value) > 1))
           % Ex. y(:) = x(2:-1:1); where y and x are 1-by-2 image acquisition object arrays.
           uddObject(index{1}) = imaqgate('privateGetField', Value, 'uddobject');
      	   type(index{1}) = imaqgate('privateGetField', Value, 'type');
       else
           % Ex. y(1) = x(2);
           % Ex. y(:) = x;
      	   uddObject(index{1}) = imaqgate('privateGetField', Value, 'uddobject');
      	   type(index{1}) = {imaqgate('privateGetField', Value, 'type')};
       end
   else
      uddObject(index{1}) = [];
      type(index{1}) = [];
   end
   
   % Assign the new state back to the original object.
   obj = isetfield(obj, 'uddobject', uddObject);
   obj = isetfield(obj, 'type', type);
catch
   errflag = 1;
   return
end
