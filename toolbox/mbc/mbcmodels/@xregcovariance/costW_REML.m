function [e,c,Wc]= costW_REML(Wp,c,YHAT,res,J,X,c0)
% LOCALMOD/COSTW_REML REstricted Maximum Likelihood cost function 
% 
% Inputs
%  Wp covariance parameters
%  L local model
%  YHAT sweepset
%  res sweepset 
%  J Jacobian for local model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:46:08 $



if nargin<7
   c0=1;
end
Gm= 0;

p= size(J{1},2);

c= update(c,Wp);
e= res;
Ns= size(res,3);
for i=1:Ns;
   
   r    = res{i};   
   yhat = YHAT{i};
   
   % Wc'*Wc=  inv( cov(L,Xs) )
   wc= choltinv(c,yhat,X{i});
   
   Jw= wc*J{i};
   if size(J{i},1)~= length(r)
      % don't like this should really use 
      nr= length(r);
      wc= wc(1:nr,1:nr);
   end
   
   Rj= qr(Jw,0);
   % problems if any diag(Rj)==0
   %  fudge it ? 
   rd= diag(abs(Rj));
   if all(rd)
      jscale= sum( log(diag(abs(Rj))) );
   else
      jscale= 0;
   end
   wd= diag(wc);
   if all(wd)
      wd= sum( log(wd ) );
   else
      wd= 0;
   end
      
   % scale factor (geometric mean) 
   Gm=   Gm + jscale - wd;
   
   % adjust residuals for gemetric mean to
   % turn log-likelihood problem into least-squares 
   e{i}= wc*r  ;
   
   Wc{i}= wc;

end   
e= double(e);
e= e * exp(Gm/(size(e,1)-p*Ns))/c0;
drawnow