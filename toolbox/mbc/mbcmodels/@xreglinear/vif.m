function v=vif(m)
%xreglinear/VIF   Partial VIFs
%   v=VIF(m) calculates Partial VIF for model
%
%
%   Calls COV and COV2CORR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:50:23 $


v=cov(m);
[s v]=xregcov2corr(v);
if all(m.Store.X(:,1)==1)
   v=v(2:end,2:end);
end
ind=~eye(size(v));
v(ind)=1./(1-v(ind).^2);
v(~ind)=inf;



