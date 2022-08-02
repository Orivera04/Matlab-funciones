function c=linfrac(z,w) 
% 
% c=linfrac(z,w)
% ~~~~~~~~~~~~~~
%
% This function determines the linear 
% fractional transformation to map any three 
% points in the z-plane into any three points 
% in the w plane. Not more than one point in 
% either the z or w plane may be located at 
% infinity.
%
% z  - vector of complex values [z1,z2,z3]
% w  - vector of complex values [w1,w2,w3]
%
% c  - vector defining the bilinear 
%      transformation
%        w=(c(1)*z + c(2))/(c(3)*z + c(4))
%
% User m functions called:  none
%----------------------------------------------

z=z(:); w=w(:); c=ones(4,1);
k=find(z==inf); j=find(w==inf); kj=[k;j];

% z and w both contain points at infinity
if length(kj)==2
  c(1)=w(k); c(4)=-z(j); w(kj)=[]; z(kj)=[];
  c(2)=(w-c(1))*z+w*c(4);
  return
end 

% z=infinity maps to a finite w point
if ~isempty(k) & isempty(j) 
  c(1)=w(k); z(k)=[]; w(k)=[];
  c([2 4])=[[1;1],-w]\[(w-c(1)).*z];
  return
end

% a finite z point maps to w = infinity
if ~isempty(j) & isempty(k)
  c(4)=-z(j); z(j)=[]; w(j)=[]; 
  c([1 2])=[z,[1;1]]\[w.*(z+c(4))];
  return
end

% case where all  points are finite
mat=[z,ones(3,1),-w];

% case for a general transformation
if det(mat)~=0
  c([1 2 4])=mat\[w.*z];
% case where transformation is linear
else
  c(3)=0; c([1 2])=[z,ones(3,1)]\w;
end