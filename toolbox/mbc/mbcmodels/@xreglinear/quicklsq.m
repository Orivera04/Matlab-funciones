function [mout,OK]= leastsq(m,x,y,Wc);
% xreglinear/LEASTSQ least squares estimate of model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.6.1 $  $Date: 2004/02/09 07:49:59 $


if nargin<4
   Wc=[];
end
J= CalcJacob(m,x);
if ~isempty(Wc)
   J= Wc*J;
   y= Wc*y;
end
% rough check
[Q,R,OK]= xregqr(J);
if OK
   % Calculate coefficients
   m.Beta= zeros(size(J,2),1);
   m.Beta(~m.TermsOut)= R\(Q'*y);
   mout=m;
else
   mout=m;
end   
