function [w,bnds]= power(c,yhat,varargin);
%POWER

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:27 $

if nargin==1
   w=1;
   bnds= [0 Inf];
else
   w= abs(yhat).^c.wparam(1);
   w(w==0)=max(w)*sqrt(eps);
end

