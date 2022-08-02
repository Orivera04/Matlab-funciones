function a = mbcCompressLogicalArray(a)
%MBCCOMPRESSLOGICALARRAY decides if a logical array should be made sparse
%
%  a = COMPRESSLOGICALARRAY(a)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:48:36 $ 

% Every true element in a takes 5 bytes in sparse so when the array is more
% than 1/5 full it is more efficient to store as full rather than sparse
if sum(a)/length(a) < 0.2;
    a = sparse(a);
else
    a = full(a);
end
