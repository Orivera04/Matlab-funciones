function out=npoints(obj)
% NPOINTS  Return the number of points in a candidate set
%
%  NP=NPOINTS(OBJ)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:14 $

% Created 15/11/2000

nf= nfactors(obj.candidateset);
if nf;
   out= 2^nf + 2*nf + obj.Nc;
else
   out=0;
end
return
