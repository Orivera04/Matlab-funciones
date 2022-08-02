function coplot(data,labels,intervalParams,fitParams)
%  make a conditioning plot for three variables
%  coplot(data,labels,intervalParams,fitParams)
%  data is a 3 column matrix with conditioning variable in first column
%  labels = {given title; dependence xlabel; dependence ylabel}
%  intervalParams = [number overlap] for conditioning variable
%  fitParams = [alpha lambda robustFlag] for loess fit

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

if size(data,2)~=3
   error('data must be a 3 column matrix')
end

%  separate the variables
given = data(:,1);
dependx = data(:,2);
dependy = data(:,3);

%  determine breakpoints for equal count intervals
np = intervalParams(1);  %  number of given intervals
overlap = intervalParams(2);
breakPoint = equalCount(given,np,overlap);  %  endpoints for the intervals

%  determine dependence subplot layout params
plotRows = floor(sqrt(np));
plotCols = ceil(np/plotRows);

%  make given plot
clf
subplot(plotRows+1,1,1)
givenplot(breakPoint)  %  basic given plot
title(labels(1))
hold on
%  add broken lines  as layout hint
for ii = 1:plotRows-1
   plot([min(breakPoint(2,:)) max(breakPoint(1,:))],[ii*plotCols+0.5 ii*plotCols+0.5],'k--')
end
hold off
set(gca,'FontSize',8)
   pos = get(gca,'Position');
   pos(4) = 0.93*pos(4);
   pos(2) = 1.04*pos(2);
   set(gca,'Position',pos)

%  get loess curve fit parameters
if nargin>3
   doFit = 1;
   alpha = fitParams(1);
   lambda = fitParams(2);
   robustFlag = fitParams(3);
end

%  reorder the plot data
plotBreakPoint = breakPoint;
for ii = 1:plotRows-1
   plotBreakPoint = [plotBreakPoint(:,end-plotCols+1:end) plotBreakPoint];
   plotBreakPoint(:,end-plotCols+1:end) = [];
end

%  compute label locations for dependence plots
xLabelPos = round((np+plotCols+np+1)/2);
yLabelPos = floor((plotRows+1)/2)*plotCols+1;

aspectRatio = zeros(1,np);

for ii = 1:np
   subplot(plotRows+1,plotCols,ii+plotCols)
   %  select points for this plot
   index = given>=plotBreakPoint(2,ii) & given<=plotBreakPoint(1,ii);
   x = dependx(index);
   y = dependy(index);
   if doFit
      %  compute loess fit if desired
      fitx = linspace(min(x),max(x),10);
      fity = loess(x,y,fitx,alpha,lambda,robustFlag);
      %  plot both
      plot(x,y,'o',fitx,fity,'-')
      %  determine dependence plot aspect ratio
      aspectRatio(ii) = aspect45(fitx,fity);
   else
      %  otherwise just plot data
      plot(x,y,'o')
   end
   %  suppress most tick labels
   if ii<np-plotCols+1
      set(gca,'XTickLabel',[])
   end
   if rem(ii,plotCols)~=1
      set(gca,'YTickLabel',[])
   end
   %  make plots slightly bigger than default
   pos = get(gca,'Position');
   pos(3:4) = 1.14*pos(3:4);
   set(gca,'Position',pos)
   set(gca,'FontSize',8)
   if ii+plotCols==xLabelPos
      xlabel(labels(2))
   end
   if ii+plotCols==yLabelPos
      ylabel(labels(3))
   end
end

if any(aspectRatio~=0)
   averageAspectRatio = mean(aspectRatio);
end

