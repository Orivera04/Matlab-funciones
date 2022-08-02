function result = subsref(obj, S)
%SUBSREF Subscripted reference into OPC Toolbox objects.
%   Obj(I) is an array formed from the elements of Obj specified by the
%   subscript vector I.
%
%   Obj.PropName returns the property value of the property named PropName
%   for OPC Toolbox object Obj.
%
%   Supported syntax for OPC Toolbox objects:
%   Dot Notation                    Equivalent Get Notation
%   ============                    =======================
%   obj.Tag                         get(obj,'Tag')
%   obj(1).Tag                      get(obj(1),'Tag')
%   obj(1:4).Tag                    get(obj(1:4),'Tag')
%   obj([true false true]).Timeout  get(obj([true false true]),'Timeout')
%
%   See also OPCROOT/GET, OPCROOT/SUBSASGN, OPCROOT/PROPINFO, OPCHELP.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.3 $  $Date: 2004/02/01 22:07:08 $

result = obj;   % Will return the entire object unless something happens below
% Handle reduction of a vector: NOTE: Will not deal with props or cells
% here
if strcmp(S(1).type, '()')
    % Find the sub-vector
    ind = S(1).subs;
    try
        obj = subvector(obj, ind);
    catch
        rethrow(mkerrstruct(lasterror));
    end
    % Now strip my struct entry
    S(1)=[];
    if isempty(S)
        result = obj;
        return;
    end
end

% Now we have the object(s). Get the properties:
switch S(1).type
    case '{}'
        rethrow(mkerrstruct('opc:subsref:cellsubs'));
    case '.' 
        % Get the property value.
        if ~all(isvalid(obj)),
            rethrow(mkerrstruct('opc:subsref:objinvalid'));
        end
        try
            result = get(obj, S(1).subs);
        catch
            % Morph the function name to subsref
            [errMsg, errID] = lasterr;
            errIDSpec = fliplr(strtok(fliplr(errID),':'));
            rethrow(mkerrstruct(sprintf('opc:subsref:%s', errIDSpec), errMsg));
        end
        S(1) = [];
    otherwise
        rethrow(mkerrstruct('opc:subsref:syntaxerror'));
end

if ~isempty(S),
    % They want a subsref of this property. We act dumb here and call
    % subsref with our new result
    result = subsref(result, S);
end

%-----------------------------------------------------------
function subObj = subvector(obj, ind)
%SUBVECTOR extracts indices from an object

% This next part taken from InstrCtrl
% Convert index1 to a cell if necessary.
if ~iscell(ind)
    ind = {ind};
end
nInd = length(ind);
if nInd>2,
    rethrow(mkerrstruct('opc:subsref:ndindexing'));
end

% Convert logicals to indices
for k=1:nInd
    if islogical(ind{k})
        % Determine which elements to extract from obj.
        indices = find(ind{k});
        % If there are no true elements within the length of obj, return.
        if isempty(indices)
            subObj = [];
            return;
        end
        % Construct new array of doubles.
        ind{k} = indices;
    end
end

% Handle the case of colons; no need to error at this stage (handled later)
isColon = false;
if length(ind) == 1 
    if ischar(ind{1}) && strcmp(ind{:}, ':')
        ind = {1:length(obj)};
        nInd = 1;
        isColon = true;
    end
else
    for k=1:nInd
        if ischar(ind{k}) && strcmp(ind{k},':')
            % They want all the elements in that dimension
            ind{k}=1:size(obj,k);
        end
    end
end

% Error if index is a non-number.
for k=1:nInd
    if ~isnumeric(ind{k})
        if ischar(ind{k})
            rethrow(mkerrstruct('opc:subsref:exceedsdims'));
        else
            rethrow(mkerrstruct('opc:subsref:undefined', ['Function ''subsindex'' is not defined for values of class ''' class(ind{k}) '''.']));
        end
    end
end

% If any of the indices is empty, return nothing
if any(cellfun('isempty', ind))
    for k = 1:nInd
        if ~isempty(ind{k}) && any(ind{k} > size(obj, k))
            rethrow(mkerrstruct('opc:subsref:exceedsdims'));
        end
    end
    subObj = [];
    return;
end

% We don't support matrices
for k=1:nInd
    if length(ind{k}) ~= (numel(ind{k}))
        rethrow(mkerrstruct('opc:subsref:matrixdisallowed'));
    end
end

% Check if the indices exist, unless we're in a colon case
if ~isColon
    if (nInd > 1),
        for k=1:nInd
            if any(ind{k} > size(obj, k)),
                rethrow(mkerrstruct('opc:subsref:exceedsdims'));
            end
        end
    else
        if (ind{1} > length(obj)),
            rethrow(mkerrstruct('opc:subsref:exceedsdims'));
        end
    end
end

% Now make sure one of the dimensions is scalar
if any(cellfun('length', ind) > prod(cellfun('length', ind)))
    rethrow(mkerrstruct('opc:subsref:matrixdisallowed'));
end

% Now we can construct the new vector
handleArray = getudd(obj);
I = find(isvalid(obj));
if isempty(I),
    rethrow(mkerrstruct('opc:subsref:objinvalid'));
end
% Find the type
thisConstructor = str2func(handleArray(I(1)).Type);
subArray = handleArray(ind{:});
% Now error out if the resulting object is invalid
if ~any(ishandle(subArray)),
    rethrow(mkerrstruct('opc:subsref:objinvalid'));
end
isColVec = isColon || ((nInd == 1) && (size(obj,1) > 1)) || (nInd == 2);
subObj = feval(thisConstructor, subArray);
if isColVec,
    subObj = subObj';
end
