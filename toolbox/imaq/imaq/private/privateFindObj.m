function output = privateFindObj(obj, varargin)
%PRIVATEFINDOBJ Find image acquisition objects.
%
%    OUT = IMAQFIND(OBJ, 'P1', V1, 'P2', V2,...) returns a cell array, OUT, of
%    image acquisition objects whose property names and property values match 
%    those passed as parameter/value pairs, P1, V1, P2, V2. The parameter/value
%    pairs can be specified as a cell array. The search is restricted to the 
%    image acquisition objects listed in OBJ. OBJ can be an array of objects.
%
%    See also IMAQDEVICE/IMAQFIND.

%    CP 7-13-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:10 $

% Initialize first.
output = {};
children = {};

% Error checking.
isParentObjects = isa(obj, 'imaqdevice');
if ~isParentObjects && ~isa(obj, 'imaqchild')
    errID = 'imaq:imaqfind:invalidType';
    error(errID, privateMsgLookup(errID));
else
    validIndices = isvalid(obj);
    if ~all(validIndices),
        % There are invalid objects.
        % Find all invalid indexes.
        inval_OBJ_indexes = find(isvalid(obj) == false);

        % Generate an error message specifying the index for the first invalid
        % object found.
        errID = 'imaq:imaqfind:invalidOBJ';
        errStr = sprintf('%s %s.',imaqgate('privateMsgLookup', errID), num2str(inval_OBJ_indexes(1)));
        error(errID, errStr);
    else
        % Extract the valid objects.
        obj = obj(isvalid(obj));        
    end
end

% Extract the UDD objects.
uddobjects = privateGetField(obj, 'uddobject');
nObjects = length(uddobjects);

% Search for the specified parameters.
parent = find(uddobjects, varargin{:});

% Convert UDD objects to MATLAB objects.
if ~isempty(parent),
    parent = privateUDDToMATLAB(parent);
else
    % FIND returns 0x1 handle array.
    parent = [];
end

% Find all children objects matching criteria.
if isParentObjects,
    for i=1:nObjects
        src = get(uddobjects(i), 'Source');
        result = find(privateGetField(src, 'uddobject'), varargin{:});
        if ~isempty(result),
            for r = 1:length(result),
                % Children need to be returned as 1x1's.
                children = {children{:} privateUDDToMATLAB(result(r))};
            end
        end
    end
end

% Return all results as a column.
output = num2cell(parent);
output = {output{:} children{:}}';
