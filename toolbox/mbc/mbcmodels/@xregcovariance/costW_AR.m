function [e,c,Wc]= costW_AR(Wp,c,YHAT,res,J,X,c0)
% COVMODEL/COSTW_AR Absolute residual cost function 
% 
% Wp covariance parameters
% L local model
% YHAT sweepset
% res sweepset 
% J Jacobian for local model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:46:06 $



if nargin<7
   c0=1;
end

Gm= 0;

c= update(c,Wp);

e= res;
Wc= cell(size(e,3),1);
Ns= length(YHAT);
for i=1:size(e,3);
   
   yhat = YHAT{i};
   r    = res{i};
   
   nr= length(r);
   % Wc'*Wc=  inv( cov(L,Xs) )
   % calculate weights of covariance model
   wc= choltinv(c,yhat(1:nr),X{i});
   
   wd= diag(wc);
   if all(wd)
      wd= sum( log(wd ) );
   else
      wd= 0;
   end

   
   % scale factor (geometric mean) 
   Gm=  Gm - wd/2;
   
   % adjust residuals for geometric mean to
   % turn log-likelihood problem into least-squares 
   e{i} = sqrt( wc*abs(r) );
   
   Wc{i}=wc;
end

% scale by geometric mean
e= double(e)*exp(Gm/size(e,1))/c0;
drawnow;