function [r,TS,res]= mle_nlcost(p,TS,Xgc,Yrf,Wci,IsNested,lsqcostParams)
% TWOSTAGE/MLE_NLCOST cost function for nested nl/linear mle
%
%
% Xgc,y should be unscaled

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:59:55 $

Nf= length(TS.Global);
st=1;
for i=1:Nf;
   Np= numNLParams(TS.Global{i});
   if Np
      % update the nonlinear global model in TS object
      TS.Global{i}=nlupdate(TS.Global{i},p(st:st+Np-1));
      st= st+Np;
   end
end

if IsNested
   % form the new jacobian
   J= jacobian(TS,Xgc,1);
   y= Yrf';
   y=y(:);
   % and solve the weighed least squares problem 
   J= Wci*J;
   y= Wci*y;
   
   Beta= J\y;
   % update parameters
   TS= mleparams(TS,Beta);
end

% this is unscaled
for i=1:Nf;
   % can overload this (e.g. penalty function lsqcost of 
   R(:,i)= lsqcost(TS.Global{i},Xgc,Yrf(:,i),[],lsqcostParams{i});
end
R=R';
% now this produces scaled residuals
r= Wci*R(:);



