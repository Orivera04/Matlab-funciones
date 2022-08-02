function [diff, index] = setdiff(obj, superset)
%SETDIFF setdiff for guidarray
%
%  [DIFF, INDEX] = SETDIFF(A, B)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:03:46 $ 

% Which guids do the two arrays have in common?
commonValues = ismember(obj, superset);
% Remove and return
diff = fastindex(obj, ~commonValues);
% Is there an extra argument out
if nargout > 1
    index = getIndicesFromArray(obj, diff);
end
