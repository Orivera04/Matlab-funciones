function [c,ceq] = swcon(knots,X,Yi,H0,k,m,varargin)
% This function checks the strict SW constraints on the 
% knots.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:00:39 $
if nargin >6
   knots= jupp2knot(knots,X(3),X(end-2));
end

c=ones(length(knots),1);
c(1)=X(3)-knots(1);
% for each knot find the data point closest (on the left)
for i=2:length(knots)
   delta=knots(i)-X;
   indx=find(delta>0);
   indx=indx(end);
   c(i)= (knots(i-1)-X(indx))*delta(indx)+1e-3;
end
% no equality constraints.
ceq=[];