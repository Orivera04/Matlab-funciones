function varargout= stats(m,opt,x,y);
% xregusermod/STATS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:01:43 $


switch lower(opt)
case 'summary'
   % [N p lam PRESS_RMSE RMSE]
   
   % p = m + k + 1
   
   
   n = length(y);
   p = length(m.parameters);
   bc= get(m,'boxcox');
   
   yhat  = eval(m,x);
   
   J= CalcJacob(m,x);
   [Q,R]= qr(J,0);
   

   
   yhatr = yinv(m,yhat);
   yraw  = yinv(m,y);
   
   res= y-yhat;
   resr   = (yraw-yhatr);
   
   % natural
   
   sser= sum( res.^2 )/(n-p);
   
   ss= sum( res.^2 );
   GCV= (ss/n)/( (n-sum(sum(Q.^2,2)))/n )^2;
   
   %   [N,p,lam,RMSE,k,GCV]
   s = [n p bc sqrt(sser) GCV];
   varargout{1}= s;
case 'validate'
   %[cookd,leverage,residuals,response,Xv,studres,yhat,ci_hi,ci_lo]= deal(dstats{:});
   %[rn,studres]= stats(m.xreg3xspline,'validate');
   if nargin < 4
      p= get(MBrowser,'CurrentNode');
      [x,y]= getdata(p.info);
   end
   varargout{1}= y(isfinite(y));
   varargout{2}= y(isfinite(y));
end