function [mout,OK]= leastsq(m,x,y,Wc);
% xreglinear/LEASTSQ least squares estimate of model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:49:42 $



if nargin<4
   Wc=[];
end
   
[m,OK]= InitModel(m,x,y,Wc);
if OK
   % Calculate coefficients
   m.Beta= zeros(size(m.Store.X,2),1);
   m.Beta(~m.TermsOut)= m.Store.R\(m.Store.Q'*m.Store.y);
   mout=m;
else
   mout=m;
end   