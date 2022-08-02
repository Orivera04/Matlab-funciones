function out=size(obj,dim)
% SIZE  returns size (number of factors) of CandidateSet
% 
% SZ=SIZE(OBJ) returns [NFACTORS 1]
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:56:50 $

% Created 1/11/2000

if nargin>1
   if dim==1
      out=npoints(obj);
   elseif dim==2
      out=nfactors(obj);
   else
      out=1;
   end
else
   out=[npoints(obj) nfactors(obj)];
end
return