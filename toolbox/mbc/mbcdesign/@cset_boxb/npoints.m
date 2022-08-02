function out=npoints(obj)
% NPOINTS  Return the number of points in a candidate set
%
%  NP=NPOINTS(OBJ)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 06:59:55 $


nf= nfactors(obj.candidateset);
if any(nf==[3 4 5])
   out=4*sum(1:nf-1)+obj.Nc;
elseif any(nf==[6 7])
   out=8*nf+obj.Nc;
else
   out=0;
end
% if nf>1
%    out= sum(1:(nf-1))*4 + obj.Nc;
% elseif nf==1
%    out=obj.Nc+2;
% else
%    out=0;
% end
