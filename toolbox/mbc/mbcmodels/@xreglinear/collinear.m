function [R2,W] = collinear(m,X);
%COLLINEAR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:18 $

if nargin==1
   X= m.Store.X;
end

In = Terms(m);
Q=m.Store.Q;
R=m.Store.R;

R2= zeros(size(m.Beta));
for i= find(In(:)')
   y  = X(:,i);
   
   Xpos= find(find(In)==i);

   [q,r]= qrdelete(Q,R,Xpos);
   q= q(:,1:end-1);
   
   r= y-q*q'*y;
   sst= sum((y).^2);
   R2(i) = (sst- sum(r.^2) )/ sst;
   
   
end   

if nargout==2
   W=eye(length(m.Beta));
   W(In,In)=corrcoef(X(:,In));
end