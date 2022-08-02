function [w,bnds]= ar1(c,yhat,X,varargin);
% COVMODEL/AR1 Auto-regressive model of order 1

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:01 $

% if length(X)<3 | all(abs( diff(X,2) ) < norm(X)*1e-8;

if nargin==1
   w= 1;
   bnds= [-1+1.0e-8 1-1.0e-8];
else
   w= c.cparam(1).^(0:length(yhat)-1);
   w= toeplitz(w);
end
