function out=fullset(obj)
% FULLSET  Return the full list of candidate points
%
%   LIST=FULLSET(OBJ) returns the full list of points in the
%   candidate set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:26 $


lims=limits(obj.candidateset)';
nf=size(lims,2);
np=npoints(obj);
cp=centerpoint(obj.candidateset);

out=repmat(cp,np,1);

mn=-ones(1,nf).*((1/nf)^0.5);
mn=diff(lims,1,1).*(mn+1)./2 + lims(1,:);
mx=(((1:nf)./nf).^0.5);
mx=diff(lims,1,1).*(mx+1)./2 + lims(1,:);



% generate in [-1 1] space
out(1,:)=mn;
for n=2:nf+1
   out(n,n:end)=mn(n:end);
   out(n,n-1)=mx(n-1);   
end