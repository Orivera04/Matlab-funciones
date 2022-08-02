function [w,bnds]= exp(c,yhat,varargin);
% COVMODEL/EXP Exponential Covariance Model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:46:15 $



if nargin==1
   w=0;
   bnds= [-Inf Inf];
else
   w= exp( (yhat).*c.wparam(1));
end

