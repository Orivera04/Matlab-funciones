function rfplot(fitted,residual,ylab)
% Make residual - fitted spread plot 
% rfplot(fitted,residual,ylab)
% The optional ylab is used as the ylabel

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

%  ignore mean value of fit
fitted = fitted-mean(fitted);

%  set uniform scale
allMax = max(max(fitted),max(residual));
allMin = min(min(fitted),min(residual));
allAxis = [0 1 allMin allMax];

%  plot fitted and residual quantiles
subplot(1,2,1)
if nargin>2
   quantileplot(fitted,ylab)
else
   quantileplot(fitted)
end   
axis(allAxis)
axis('square')
title('Fitted Values')
subplot(1,2,2)
quantileplot(residual)
title('Residuals')
axis(allAxis)
axis('square')
%  adjust figure shape
pos = get(gcf,'Position');
pos(4) = pos(3)/2;
set(gcf,'Position',pos)
papos = get(gcf,'Position');
papos(4) = papos(3)/2;
set(gcf,'Position',papos)
