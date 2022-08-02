function obj = privateSubsasgn(obj, Struct, Value, classErrID, className)
%PRIVATESUBSASGN Subscripted assignment into image acquisition objects.
%
%    PRIVATESUBSASGN Subscripted assignment into image acquisition objects. 
%
%    OBJ(I) = B assigns the values of B into the elements of OBJ specifed by
%    the subscript vector I. B must have the same number of elements as I
%    or be a scalar.
% 
%    OBJ(I).PROPERTY = B assigns the value B to the property, PROPERTY, of
%    image acquisition object OBJ.
%

%    CP 1-24-03
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:17 $

% Initialize variables.
prop1 = '';
index1 = {};
StructL = length(Struct);

% Define possible error IDs.
errID1 = 'imaq:subsasgn:invalidParens';
errID2 = 'imaq:subsasgn:cellRef';
errID3 = 'imaq:subsasgn:invalidDot';
errID4 = 'imaq:subsasgn:elementMismatch';
errID5 = 'imaq:subsasgn:negativeIndex';
errID6 = 'imaq:subsasgn:noGaps';
errID7 = 'imaq:subsasgn:unknownType';
errID9 = 'imaq:subsasgn:useClear';
errID8 = 'imaq:subsasgn:dimensionExceeded';

% Assuming obj is originally empty...
if isempty(obj)
    % Ex. obj(1) = videoinput('matrox', 1);
    if (isequal(Struct.type, '()') && isequal(Struct.subs{1}, 1:length(Value)))
        obj = Value;
        return;
    elseif length(Value) ~= length(Struct.subs{1})
        % Ex. obj(1:2) = videoinput('matrox', 1);
        errStruct.message = privateMsgLookup(errID4);
        errStruct.identifier = errID4;
        rethrow(errStruct);
    elseif Struct.subs{1}(1) <= 0
        % Ex. obj(-3) = videoinput('matrox', 1);
        errStruct.message = privateMsgLookup(errID5);
        errStruct.identifier = errID5;
        rethrow(errStruct);
    else
        % Ex. obj(2) = videoinput('matrox', 1); and av is []..
        errStruct.message = privateMsgLookup(errID6);
        errStruct.identifier = errID6;
        rethrow(errStruct);
    end
end

% The first Struct can either be:
switch Struct(1).type
    case '.'
        % Ex. obj.FramesPerTrigger = 10;
        prop1 = Struct(1).subs;
    case '()'
        % Ex. obj(1) = obj(2); 
        index1 = Struct(1).subs;
        if strcmp(index1, ':')
            index1 = 1:length(obj);
        end
    case '{}'
        % Ex. obj{3} = obj(2);
        errStruct.message = privateMsgLookup(errID2);
        errStruct.identifier = errID2;
        rethrow(errStruct);
    otherwise
        errStruct.message = [privateMsgLookup(errID7) Struct(1).type,'.'];
        errStruct.identifier = errID7;
        rethrow(errStruct);
end

if StructL > 1
    % Ex. obj(1).TimerFcn = 'mycallback' creates:
    %    Struct(1) -> () and 1
    %    Struct(2) ->  . and 'TimerFcn'
    %    StrcutL   ->  3
    switch Struct(2).type
        case '.'
            if isempty(index1)
                % Ex. obj.FramesAvailable.Prop2 = 5
                errStruct.message = privateMsgLookup(errID3);
                errStruct.identifier = errID3;
                rethrow(errStruct);
            else
                % Ex. obj(1).TimerFcn = 'mycallback';
                % Ex. obj(2).FramesPerTrigger = 10
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
            errStruct.message = [privateMsgLookup(errID7) Struct(2).type,'.'];
            errStruct.identifier = errID7;
            rethrow(errStruct);
    end  
end   

% Index1 will be entire object if not specified.
if isempty(index1)
    index1 = 1:length(obj);
end

% Convert index1 to a cell if necessary.
if ~iscell(index1)
    index1 = {index1};
end

% Set the specified value.
if ~isempty(prop1)
    % Ex. obj.FramesPerTrigger = 10
    % Ex. obj(2).FramesPerTrigger = 10
    
    % Extract the object.
    [indexObj, errflag] = localIndexOf(obj, index1);
    if errflag
        rethrow(lasterror);
    end
    
    % Set the property.
    try
        set(indexObj, prop1, Value);
    catch
        rethrow(lasterror);
    end
else
    % Ex. obj(2) = obj(1);
    if (~(isa(Value, className) || isempty(Value)))
        errStruct.message = privateMsgLookup(classErrID);
        errStruct.identifier = classErrID;
        rethrow(errStruct);
    end
    
    % Ex. obj(1) = [] and obj is 1-by-1.
    if ((length(obj) == 1) && isempty(Value))      
        errStruct.message = privateMsgLookup(errID9);
        errStruct.identifier = errID9;
        rethrow(errStruct);
    end
    
    % Error if a gap will be placed in array.
    % Ex. obj(4) = obj2 and obj is 1-by-1.
    if (max(index1{:}) > length(obj)+1)      
        errStruct.message = privateMsgLookup(errID8);
        errStruct.identifier = errID8;
        rethrow(errStruct);
    end
    
    % If the objects are the same length replace.
    if ((length(index1{:}) == length(Value)) || isempty(Value) || (length(Value) == 1))
        [obj, errflag] = localReplaceElement(obj, index1, Value);
        if errflag
            rethrow(lasterror);
        end	
    else
        errStruct.message = privateMsgLookup(errID4);
        errStruct.identifier = errID4;
        rethrow(errStruct);
    end	
end

% *********************************************************************
% Index into an image acquisition array.
function [result, errflag] = localIndexOf(obj, index)

% Initialize variables.
errflag = false;
result = obj;

try
    % Get the field information of the entire object.
    uddobj = privateGetField(obj, 'uddobject');
    type = privateGetField(obj, 'type');
    
    % Create result with only the indexed elements.
    result = isetfield(result, 'uddobject', uddobj(index{:}));
    result = isetfield(result, 'type', type(index{:}));
catch
    lasterr('Index exceeds matrix dimensions.');
    errflag = true;
end

% *********************************************************************
% Replace the specified element.
function [obj, errflag] = localReplaceElement(obj, index, Value)

% Initialize variables.
errflag = false;

try
    % Get the current state of the object.
    uddobject = privateGetField(obj, 'uddobject');
    type = privateGetField(obj, 'type');
    
    % Replace the specified index with Value.
    if ~isempty(Value)
        uddobject(index{1}) = privateGetField(Value, 'uddobject');
        type(index{1}) = privateGetField(Value, 'type');
    else
        uddobject(index{1}) = [];
        type(index{1}) = [];
    end
    
    % Assign the new state back to the original object.
    obj = isetfield(obj, 'uddobject', uddobject);
    obj = isetfield(obj, 'type', type);
catch
    errflag = true;
end
