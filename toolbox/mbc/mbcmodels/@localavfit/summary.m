function [s]= summary(L,X,y,Wc);
% LOCALMOD/SUMMARY localmod statistics
%
% 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.2 $  $Date: 2004/02/09 07:37:56 $



% sse     SSE
% df      nobs-p 
% ssen    natural SSE
% R2 
% cond(J) condition of jacobian

[r,J,yhat]= lsqcost(L,X,y,Wc);

sse = sum(r.^2);               % Residual sum of squares.
if islinear(L.model) & IncludeConst(L.model)
   sst = sum((y-mean(y)).^2);     % Total sum of squares.
else
   sst = sum((y).^2);     % Total sum of squares.
end   
ssr = sst-sse;
nobs = length(y);
p   = numParams(L);
if nobs>p
   mse = sse/nobs;
else
   mse = 0;
end   

if sst==0
   R2= 1;
else
   R2   = ssr/sst;
end

rn= CalcYinv(L,y) - CalcYinv(L,yhat);
   
% 
rn= rn(isfinite(rn));
if ~isreal(rn)
   rn(imag(rn)~=0)=[];
end
ssen = sum(rn.^2);
[ri,s2,df]= var(L);

s.sse         = sse;
s.SSE_natural = ssen;
s.df          = nobs;
s.nobs        = nobs;
s.R2          = R2;
s.mse         = mse;
