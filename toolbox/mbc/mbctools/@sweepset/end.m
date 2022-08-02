function m=end(A,k,n);
% SWEEPSET/END overloaded end operator for sweepset

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:06:11 $



if n==1
   m= size(A,3);
else
   m= size(A,k);
end
