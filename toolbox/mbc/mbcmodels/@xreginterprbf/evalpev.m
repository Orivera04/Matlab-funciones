function PEV= evalpev(x,m,FindMax,YVAR);
% xreglinear/EVALPEV evaluate Prediction Error Variance for model
%
% PEV = evalpev(x,m,FindMax)
%   x is in coded units
%   m is the model. InitStore must be called on m before this function
%   FindMax==1 returns -PEV for use in maximising PEV (i.e. G optimality)
% 
% If y data is available
%     PEV = x'* s^2*inv(X'*X) * x
% otherwise PEV = x'* inv(X'*X) * x
% 
% See also xreglinear/PEVGRID

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:48:43 $ 


PEV= zeros(size(x,1),1);

   
