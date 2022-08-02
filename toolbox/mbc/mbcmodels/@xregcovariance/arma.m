function [w,bnds]= ar(c,yhat,X,varargin);
% COVMODEL/ARMA Auto-regressive Moving Average model 
%
% order(MA) = order(AR) or order(AR)-1 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:29:56 $


if nargin==1
   w= 1;
   bnds= [];
else
   ny= length(yhat);
   x= [1 zeros(1,ny-1)];
   nb= floor(length(c.param)/2);
   b= [1 c.param(1:nb)];
   a= [1 -c.cparam(nb+1:end)];
   w= filter(b,a,x);
   w= toeplitz(w);
end
