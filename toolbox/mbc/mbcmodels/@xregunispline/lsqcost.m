function [r,J,yhat]= lsqcost(m,x,y,Wc,alpha);
% MV_UNISPLINE/LSQCOST
%
% [r,yhat,J]= lsqcost(m,x,y,Wc);
%   m   model object
%   x   coded x values
%   y   ytrans
%   Wc, the weights, are optional
% Outputs
%   r    residuals (weights and TBS adjusted)
%   yhat estimated (transformed)
%   J    jacobian (is not calculated if nargout<3)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:58:38 $

yhat= eval(m,x);
if nargout>1
   J= jacobian(m,x,1,yhat);
end

% deal with TBS
if get(m,'TBS')
   yhat= ytrans(m,yhat);
end

r= y-yhat;

if nargin > 4
   % modify residuals by 
   knots= get(m.mv3xspline,'knots');
   h=diff([-1;knots(:);1])/2;
   h(h<1e-6)=1e-6;
   penalty= -alpha*sum(log((length(knots)+1)*h))+1;
   
   r= penalty*r;
end
% modify residuals and jacobian by weights
if nargin>3 & ~isempty(Wc)
   r= Wc*r;
   if nargout>1
      J= Wc*J;
   end
end



