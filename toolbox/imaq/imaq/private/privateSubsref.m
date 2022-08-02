function result = privateSubsref(obj, Struct)
%PRIVATESUBSREF Subscripted reference into image acquisition objects.
%
%    PRIVATESUBSREF Subscripted reference into image acquisition objects.
%
%    OBJ(I) is an array formed from the elements of OBJ specifed by the
%    subscript vector I.  
%
%    OBJ.PROPERTY returns the property value of PROPERTY for image 
%    acquisition object OBJ.
%

%    CP 1-24-03
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:18 $

% Initialize variables.
prop1 = '';
index1 = {};
StructL = length(Struct);

% Define possible error IDs.
errID1 = 'imaq:subsref:invalidParens';
errID2 = 'imaq:subsref:cellRef';
errID3 = 'imaq:subsref:invalidDot';
errID4 = 'imaq:subsref:unknownType';
errID5 = 'imaq:subsref:noMatrix';
errID6 = 'imaq:subsref:invalidIndex';

% The first Struct can either be:
switch Struct(1).type
    case '.'
        % Ex. obj.FramesPerTrigger;
        prop1 = Struct(1).subs;
    case '()'
        % Ex. obj(1); 
        index1 = Struct(1).subs;
    case '{}'
        % obj{1}
        errStruct.message = privateMsgLookup(errID2);
        errStruct.identifier = errID2;
        rethrow(errStruct);
    otherwise
        errStruct.message = [privateMsgLookup(errID4) Struct(1).type,'.'];
        errStruct.identifier = errID4;
        rethrow(errStruct);
end

if StructL > 1
    % Ex. obj(1).FramesPerTrigger;
    switch Struct(2).type
        case '.'
            if isempty(index1)
                % Ex. obj.FramesPerTrigger.Prop2
                errStruct.message = privateMsgLookup(errID3);
                errStruct.identifier = errID3;
                rethrow(errStruct);
            else
                % Ex. obj(1).FramesPerTrigger;
                prop1 = Struct(2).subs;
            end
        case '()'
            errStruct.message = privateMsgLookup(errID1);
            errStruct.identifier = errID1;
            rethrow(errStruct);
        case '{}'
            errStruct.message = privateMsgLookup(errID2);
            errStruct.identifier = errID2;
            rethrow(errStruct);
        otherwise
            errStruct.message = [privateMsgLookup(errID4) Struct(1).type,'.'];
            errStruct.identifier = errID4;
            rethrow(errStruct);
    end  
end   

% Index1 will be entire object if not specified.
if isempty(index1)
    index1 = 1:length(obj);
end

% Convert index1 to a cell if necessary. Handle the case
% when a ':' is passed, which requires a column vector to
% be returned.
isColon = false;
if ~iscell(index1)
    index1 = {index1};
end

% Error if index is a non-number.
for i=1:length(index1)
    ind = index1{i};
    if ~isnumeric(ind) && ~islogical(ind) && (~(ischar(ind) && (strcmp(ind, ':'))))
        errStruct.message = [privateMsgLookup(errID6), '.'];
        errStruct.identifier = errID6;
        rethrow(errStruct);
    end
end

if any(cellfun('isempty', index1))
    result = [];
    return;
elseif (length(index1{1}) ~= (numel(index1{1})))
    errStruct.message = privateMsgLookup(errID5);
    errStruct.identifier = errID5;
    rethrow(errStruct);
elseif length(index1) == 1 
    if strcmp(index1{:}, ':')
        isColon = true;
        index1 = {1:length(obj)};
    end
else
    for i=1:length(index1)
        if (strcmp(index1{i}, ':'))
            index1{i} = 1:size(obj,i);
        end
    end
end

% Return the specified value.
if ~isempty(prop1)
    % Ex. obj.BaudRate 
    % Ex. obj(2).BaudRate
    
    % Extract the object.
    [indexObj, errflag] = localIndexOf(obj, index1, isColon);
    if errflag,
        rethrow(lasterror);
    end
    
    % Get the property value.
    try
        result = get(indexObj, prop1);
    catch
        rethrow(lasterror);
    end
else
    % Ex. obj(2);
    
    % Extract the object.
    [result, errflag] = localIndexOf(obj, index1, isColon);   
    if errflag
        rethrow(lasterror);
    end
end

% *********************************************************************
% Index into an image acquisition array.
function [result, errflag] = localIndexOf(obj, index1, isColon)

% Initialize variables.
errflag = false;
result = [];
try
    % Get the field information of the entire object.
    uddobj = privateGetField(obj, 'uddobject');
    type = privateGetField(obj, 'type');
    
    % Check if all indices are false logicals.
    if islogical([index1{:}]) && ~any(index1{:})
        err.identifier = 'imaq:subsref:badsubscript';
        err.message = privateMsgLookup(err.identifier);
        lasterror(err);
        errflag = true;
        return
    end
    
    % Redefine the object to contain the right UDD items.
    result = obj;
    result = isetfield(result, 'uddobject', uddobj(index1{:}));
    result = isetfield(result, 'type', type(index1{:}));   
    if isColon
        result = result';
    end
catch
    errflag = true;
    return;
end
