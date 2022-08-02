function Index = getIndexFromDatakey(obj, datakey)
%GETINDEXFROMDATAKEY Return indices of datakeys
%
%  INDEX = GETINDEXFROMDATAKEY(OBJ, DATAKEY) returns a list of indices for
%  each of the keys in the list DATAKEY.  Invalid datakeys return an index
%  of 0.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:20 $ 

Keys = obj.DataKeyTable(:, 2);
NKeys = length(Keys);
Index = zeros(size(datakey));
for n = 1:length(datakey)
    k = 1;
    % Find first instance of L(n) in Keys
    while k<=NKeys && datakey(n)~=Keys(k)  
        k = k + 1;
    end
    if k<=NKeys
        % L(n) is found at k
        Index(n) = k;
    end
end
