function [PEV,s] = MeanPredVar(m)
% xreg3xspline/MEANPREDVAR calculates the Mean Prediction Variance over [-1 1].
%
% It is called with the model that is being used
% InitStore must have been run on this model
%    [PEV,s] = MeanPredVar(m)
%       PEV is mean value
%       s is a square matrix such that PEV= trace(cov(m)*s)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:21 $


% Aly 3/6/99



limsK= unique([-1 m.knots(:)' 1]);
N= nfactors(m);
UpperLim= ones(1,N);
LowerLim= -UpperLim;

ulim= UpperLim;
llim= LowerLim;

TotInt=0;
s=zeros(NumTerms(m));
for i= 2:length(limsK)
   % now call quad, passing in limits, and parameters
   llim(m.splinevar)= limsK(i-1);
   ulim(m.splinevar)= limsK(i);
   [int,si]= pevint(m,llim,ulim);
   if nargout > 1
      s= s + si;
   end
   TotInt=TotInt + int;
end

PEV= TotInt/prod(UpperLim-LowerLim);
if nargout > 1
   s= s/prod(UpperLim-LowerLim);
end
return
