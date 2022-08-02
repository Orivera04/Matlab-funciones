function [Resids,J,LMout]= fit(param,LM,X,Y)
% LOCALMOD/FIT obtains least squares estimate of a Local Model fit
%
% [LM,BINT,R,RINT,STATS]= POLYFIT(param,LM,X,Y)
%
%
% Inputs    QS0   Initial quadratic spline
%           X     X Data (normally SPARK)
%           Y     Y Data (normally TORQUE)
%           param Alpha, Gamma, Kappa
%
% Outputs   LM    Least Squares estimate of local model
%           BINT  Confidence Intervals for [k b0 bl br] 
%           R     Residuals
%           RINT  Confidence interval fot residuals
%           stats Statistics describing fit [R^2 F p]

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:39:02 $




% Number of parameters
Np=size(param,2);
Ns=size(X,3);
% Make sure data is in columns
st= [tstart(Y) size(Y,1)+1];
Resids= zeros(size(Y,1),1);
if nargin>=2
   J= spalloc(size(Y,1),size(Y,3)*Np,size(Y,1)*Np);
end
if nargin >= 3
   LMout={LM};
   LMout= repmat(LMout,1,size(Y,3));
end
Ji= zeros(size(X,1)); %No of records
for i= 1:Ns% loop over sweeps
   x= double(X(:,:,i));
   y= double(Y(:,:,i));
   
   % Residual calculation
   LMout{i}=set(LMout{i},'Param',param(i,:));
   Resids(st(i):st(i+1)-1) = y - eval(LMout{i},x);%subplot(211);hold on;plot(x,Resids);subplot(212);hold on;plot(x,eval(LM,x));

   if nargout>=2
      % Jacobian calculation
      Ji=jacob(LMout{i},x);
           
      % Fill in sparse Jacobian matrix with Nr*Np block
      J(st(i):st(i+1)-1,i:Ns:i+(Np-1)*Ns)= Ji;
   end
   if nargout>=3
      % Model Calculation - Set stats in store 
      Store.X= x;
      Store.y= y;
      Store.r= Resids(st(i):st(i+1)-1);
      Store.Jacob= Ji;
      LMout{i}=set(LMout{i},'Store',Store);
   end
end