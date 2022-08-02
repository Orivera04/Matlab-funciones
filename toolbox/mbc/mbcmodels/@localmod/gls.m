function [L,B,Wc,sigma2,J]= gls(L,X,Y,B,Wc);
% LOCALMOD/GLS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:39:06 $

%L.covmodel = covmodel('power','');
% hard-coded for the moment

global STOP


DATA= [X,Y];

if any(cellfun('isempty',Wc)) 
   DisplayFit(L,'OLS for initial parameter estimates');
   
   OK= all(isfinite(B),1);
   
   B= B(:,OK);
   
   [B,yhat,res,J]= gls_fitB(L,B,DATA);
   
   
   for i=1:size(Y,3)
      Xs= X(:,:,i);
      if ~isempty(L.covmodel)
         Wc{i}= choltinv(L.covmodel,yhat{i},X{i});
      end
   end
   
end


df= (size(Y,1)- size(Y,3)*size(L,1));

[res,J]= gls_costB(B,L,DATA,Wc);
Cost= sqrt(sum(double(res).^2)/df);

% calculate initial model fit, residuals etc
[res,Jr,yhat]= gls_costB(B,L,DATA);

if ~isempty(L.covmodel)
   for i=1:size(Y,3)
      if size(Wc{i},1)~= length(yhat{i})
         Wc{i}= choltinv(L.covmodel,yhat{i},X{i});
      end
   end
end



iter=0;
RUNNING=~isempty(L.covmodel);
STOP=0;

maxiter=100;
if RUNNING
   str= sprintf('   Iter %9s %9s %9s %9s','sigma','norm(B)','norm(C)','cparam');
   DisplayFit(L,str);
   str= sprintf('GLS:%3d %9.5g ',0,Cost);
   str = [str sprintf('%9.5g ', norm(B),norm(double(L.covmodel)))];
   str = [str sprintf('%9.5g ', double(L.covmodel))];
   DisplayFit(L,str);
end
while RUNNING & ~STOP
   OldCost= Cost;
   oldB= B;
   oldW= double(L.covmodel);
   
   iter= iter+1;
   
   [L.covmodel,Wc]= gls_FitW(L.covmodel,yhat,res,Jr,X);
   
   % update parameter estimates
   % run lsqnonlin
   [B,yhat,res,J]= gls_fitB(L,B,DATA,Wc);
   
   res= gls_costB(B,L,DATA,Wc);
   Cost= sqrt(sum(double(res).^2)/df);
   
   % need raw residuals for next step
   [res,Jr,yhat]= gls_costB(B,L,DATA);
   
   % 
   deltaC= norm(Cost-OldCost);
   deltaB= norm(B-oldB);
   deltaW= norm(oldW-double(L.covmodel));
   
   str = sprintf('GLS:%3d %9.5g ',iter,Cost);
   str = [str sprintf('%9.5g ', norm(B),norm(double(L.covmodel)))];
   str = [str sprintf('%9.5g ', double(L.covmodel))];
   DisplayFit(L,str);
   if (deltaC/Cost < L.FitOptions.TolSigma) | ...
         (deltaB < L.FitOptions.TolParams) | ...
         (deltaW < L.FitOptions.TolCov) | ...
         (iter >= L.FitOptions.MaxIter)
      RUNNING=0;
   end
end


sigma2= Cost.^2;
