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


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:28 $

if nfactors(m)==1 
   x=x(:);
elseif any(size(x)==1) 
   x=x(:)';
end

Ri= var(m);
if ~isempty(Ri)
    FX= CalcJacob(m,x);
    % calculate inverse and use multiplication
    pev= FX*Ri;
    PEV= sum(pev.^2,2);
else
    PEV= zeros(size(x,1),1);
    PEV(:)=NaN;
end
    


if nargin==3 & FindMax
   PEV= -PEV;
end

   
