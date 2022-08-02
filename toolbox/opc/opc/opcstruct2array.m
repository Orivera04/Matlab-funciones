function [i, v, q, ts, et] = opcstruct2array(s, dataType)
%OPCSTRUCT2ARRAY Convert OPC Data from structure to array format.
%   [ItmID,Val,Qual,TStamp,EvtTime] = OPCSTRUCT2ARRAY(S) converts the OPC
%   Data structure S into separate arrays for the item ID, value, quality,
%   time stamp, and event time. S must be a structure as returned by the
%   GETDATA and OPCREAD functions. S must contain the fields LocalEventTime
%   and Items. The Items field of S must contain the fields ItemID, Value,
%   Quality, and TimeStamp.
%
%   - ItmID is a 1-by-nItm cell array containing the item IDs of all unique
%   items found in the ItemID field of the Items structures in S.
%   - Val is an nRec-by-nItm array of doubles containing the value of each
%   item in ItmID, at each time specified by TStamp. 
%   - Qual is an nRec-by-nItm cell array of strings containing the quality
%   of each value in Val. 
%   - TStamp is an nRec-by-nItm array of doubles containing the time stamp
%   for each value in Val. 
%   - EvtTime is nRec-by-1 array of doubles containing the local time each
%   data change event occurred.
% 
%   Each row of Val represents data from one record received by the OPC
%   Toolbox at the corresponding entry in EvtTime, while each column of Val
%   represents the time series for the corresponding item ID in ItmID.
%
%   [ItmID,Val,Qual,TStamp,EvtTime] = OPCSTRUCT2ARRAY(S,'DataType') uses
%   the data type specified by the string DataType for the Value array.
%   Valid data types are any MATLAB numeric data type, plus 'logical' and 
%   'cell'.
% 
%   See Also DAGROUP/GETDATA, OPCREAD.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.2 $ $Date: 2004/03/24 20:43:39 $

errMsg = nargchk(1, 2, nargin, 'struct');
if ~isempty(errMsg),
    rethrow(mkerrstruct('opc:opcstruct2array:inargs', errMsg));
end

if nargin<2,
    dataType = 'double';
else
    % Check that data type is valid.
    validTypes = {'cell', ...
        'double', 'single', 'logical', ...
        'uint8', 'uint16', 'uint32', 'uint64',...
        'int8', 'int16', 'int32', 'int64'};
    if ~any(strcmp(dataType, validTypes)),
        rethrow(mkerrstruct('opc:opcstruct2array:datatypeinvalid'));
    end
end
% Check that S is the right structure
if ~isopcstruct(s),
    rethrow(mkerrstruct('opc:opcstruct2array:invalidstruct', ...
        'Argument to OPCSTRUCT2ARRAY must be an OPC Structure.'));
end
% Now convert
numRec = length(s);
% Check if the data is required.
i = parseitemids(s);    % Always need this
numItem = length(i);
isCellVal = strcmpi(dataType, 'cell');
isLogicalVal = strcmpi(dataType, 'logical');
if nargout>=2,
    if isCellVal,
        v = cell(numRec, numItem);
    elseif isLogicalVal
        v = false(numRec, numItem);
    else
        v = zeros(numRec, numItem, dataType);
    end
end
if nargout >=3,
    q = cell(numRec, numItem);
end
if nargout >=4,
    ts = zeros(numRec, numItem);
end
if nargout ==5,
    et = zeros(numRec, 1);
end

for k=1:numRec,
    if nargout>=2,
        vals = parseitemstruct(s(k).Items, i, 'Value');
        % Deal with missing values
        for c = 1:numItem,
            if isCellVal,
                v(k,c) = vals(c);
            elseif isLogicalVal,
                try
                    v(k,c) = vals{c}~=0;
                catch
                    % Do nothing
                end
            else
                % Real numeric array or logical.
                try
                    v(k,c) = vals{c};
                catch
                    % Data does not exist or is a vector
                    if k==1,
                        v(k,c) = NaN;
                    else
                        v(k,c) = v(k-1, c);
                    end
                end
            end
        end
    end
    if nargout >=3,
        q(k,:) = parseitemstruct(s(k).Items, i, 'Quality');
    end
    if nargout >=4,
        thisTS = parseitemstruct(s(k).Items, i, 'TimeStamp');
        % Get rid of empty cell arrays
        allTS = [thisTS{:}];
        replaceTS = datenum(allTS(1:6));   % Take the first
        % Now deal with missing values
        for c=1:numItem
            if isempty(thisTS{c}),
                %DEBUG: FIX THIS!
                ts(k,c)=replaceTS;
            else
                ts(k,c) = datenum(thisTS{c});
            end
        end
    end
    if nargout ==5,
        et(k) = datenum(s(k).LocalEventTime);
    end
end

% Now we fill the empty values with the previous one
if nargout>=3,
    for kr=1:numRec,
    for ki=1:numItem
        if isempty(q{kr,ki}), 
            q{kr,ki} = 'Repeat';
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function b = isopcstruct(s)
%ISOPCSTRUCT Returns true if the struct is an OPC structure
b = isstruct(s) && ...
    isfield(s,'LocalEventTime') && ...
    isfield(s,'Items');
if b,
    % Check all the elements
    s1 = s(1).Items;
    b = isstruct(s1) && ...
        isfield(s1, 'ItemID') && ...
        isfield(s1, 'Value') && ...
        isfield(s1, 'Quality') && ...
        isfield(s1, 'TimeStamp');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function itmList = parseitemids(s)
%PARSEITEMIDS Returns all item ids in the order they were found
itmList = {};
for k=1:length(s);
    itmList = union(itmList, {s(k).Items.ItemID});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function v = parseitemstruct(itmStruct, itemIDs, fieldName)
%PARSEITEMSTRUCT Returns information from fieldName in itemIDs order
v = cell(1,length(itemIDs));
[tf, vInd, sInd] = intersect(itemIDs, {itmStruct.ItemID});
for k=1:length(sInd)
    v{vInd(k)} = itmStruct(sInd(k)).(fieldName);
end
