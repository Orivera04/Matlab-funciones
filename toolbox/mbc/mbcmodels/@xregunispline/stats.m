function varargout= stats(m,opt,x,y);
%STATS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:00:36 $

s = stats(m.mv3xspline,opt);
switch lower(opt)
case 'summary'
   % [N p lam PRESS_RMSE RMSE]
   
   % p = m + k + 1
   
   k= get(m.mv3xspline,'numknots');
   % sse = (RMSE*(N-p))^2
   sse= s(5)^2*(s(1)-s(2)); 
   
   dstats= stats(m.mv3xspline,'diagnostics');
   leverage= dstats{2};
   res= dstats{3};
   gcv= calcGCV(m.mv3xspline);
   %   [N,p,lam,RMSE,k,GCV]
   s = [s([1:2]),get(m,'boxcox'),s(5),k,log10(gcv)];
   varargout{1}=s;
case 'validate'
   %[cookd,leverage,residuals,response,Xv,studres,yhat,ci_hi,ci_lo]= deal(dstats{:});
   %[rn,studres]= stats(m.mv3xspline,'validate');
   if nargin < 4
      p=get(MBrowser,'CurrentNode');
      [x,y]= getdata(p.info);
   end
   varargout{1}= y(isfinite(y));
   varargout{2}= y(isfinite(y));
end