function [Index, Exists] = getIndexFromTable(obj, varargin)
%GETINDEXFROMTABLE Return indices of table cell links
%
%  INDEX = GETINDEXFROMTABLE(OBJ, R, C) returns the indices of the datakeys
%  that are linked to the table cells defined by the list (R, C). 
%
%  [INDEX, EXISTS] = GETINDEXFROMTABLE(...) also returns a logical vector
%  the same length as INDEX that indicates whether or not a datakey exists
%  for each (R, C) pair.  Datakeys that do not exist have a corresponding
%  index of 0.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:21 $

L = uint32(sub2ind(obj.TableSize, varargin{:}));
Keys = obj.DataKeyTable(:, 1);
NKeys = length(Keys);
Index = zeros(size(L));
Exists = false(size(L));
for n = 1:length(L)
    k = 1;
    % Find first instance of L(n) in Keys
    while k<=NKeys && L(n)~=Keys(k)  
        k = k + 1;
    end
    if k<=NKeys
        % L(n) is found at k
        Index(n) = k;
        Exists(n) = true;
    end
end
