function [OK, location] = ismember(obj, indexer)
%GUIDARRAY/ISMEMBER returns logical true if element in obj is in indexer

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.2 $ 

% Check that indexer is a GUIDARRAY
switch class(indexer)
    case 'guidarray'
    otherwise
        error('mbc:guidarray:InvalidArgument', 'The second argument must be a guidarray object');
end

[sortedValues, sortedIndex] = getHash(indexer);
% TO DO - Faster find than ismembc2 which makes use of both hash's
% Find indexer values in obj hash table
if nargout < 2
    OK = ismembc(obj.values, sortedValues);
else
    % Find the locations using the ismembc2 member function
    location = ismembc2(obj.values, sortedValues);
    % Then get the OK flags from the locations
    OK = location > 0;
    % Reindex
    location(OK) = sortedIndex(location(OK));
end
