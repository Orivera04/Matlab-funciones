function B = fastindex(A, index)
%GUIDARRAY/FASTINDEX fast subsref function

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

B = A;
% Index into array
B.values = A.values(index);
% Update the hash
B = updateHash(B);
