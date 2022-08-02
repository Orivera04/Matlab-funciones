function rdplot(xin,residual,alpha,lambda)
%  make residual dependence plot of (xin,residual )with optional loess fit
%  rdplot(xin,residual,alpha,lambda)
%  alpha and lambda are the loess fit parameters
%  if they are missing, no fit is plotted

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

if nargin<4
   plot(xin(:),residual(:),'o',[min(xin) max(xin)],[0 0],'--')
else
   xfit = linspace(min(xin),max(xin),50);
   fit = loess(xin,residual,xfit,alpha,lambda);
   plot(xin(:),residual(:),'o',xfit,fit,'-',[min(xin) max(xin)],[0 0],'--')
end