function [bestknots,sse]=eval_model(m,knots,X,Y,best)
% This function performs one off xreg3xspline
% evaluations using a vector of knot positions
% and selects the best n%
%
% eval_model(m,X,Y,'best') will return the best knot vector

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:58:24 $

% Build some test data
%xdata=[linspace(-1,1,100)]';
%ydata=spline(X,Y,xdata);
KNOT_NUMBER= size(knots,2);
LEN=size(knots,1);
for i=1:LEN
   m3= set(m.mv3xspline,'knots',knots(i,:));
   m3=leastsq(m3,X,Y);
   sse(i)=sum((Y-eval(m3,X)).^2);
end

[sse,ind]=sort(sse);
knots=knots(ind,:);
if nargin <4
   bestknots=knots(1:round(LEN/10),:);
elseif nargin>3 & isnumeric(best)
   bestknots=knots(1:round(LEN*best/100),:);
elseif nargin > 3 & isstr(best)
   bestknots=knots(1,:);
end
