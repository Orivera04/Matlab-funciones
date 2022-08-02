function boxplotter(params,outsideValues,names)
%  make box or whisker plots
%  boxplotter(params,outliers,names)
%  params from boxparams.m
%  outsideValues from boxparams.m
%  names of the data series

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

nb = size(params,1);  %  number of boxplots
hw = 0.25;   %  halfwidth of boxes

%  if names are not given, make some
if nargin<3
   for ii = 1:nb
      names{ii} = ['Series' int2str(ii)];
   end
end

%  plot medians
plot(params(:,3),1:nb,'.','MarkerSize',18)
%  uses names for labels
set(gca,'YTick',1:nb)
set(gca,'YLim',[0 nb+1])
set(gca,'YTickLabel',char(names))
set(gca,'YDir','reverse')

hold on
%  plot quartiles as box
for ii = 1:nb
   temp1 = params(ii,2);
   temp2 = params(ii,4);
   xx = [temp1 temp1 temp2 temp2 temp1];
   yy = [ii-hw ii+hw ii+hw ii-hw ii-hw];
   plot(xx,yy,'-')
end
%  plot adjacent values
for ii = 1:nb
   plot([params(ii,1) params(ii,2)],[ii ii],'--')
   plot([params(ii,4) params(ii,5)],[ii ii],'--')
   plot([params(ii,1) params(ii,1)],[ii-hw ii+hw],'--')
   plot([params(ii,5) params(ii,5)],[ii-hw ii+hw],'--')
end
%  plot outside values
if exist('outsideValues')
   plot(outsideValues(:,2),outsideValues(:,1),'o')
end
hold off

%  make some extra space
axlim = axis;
axlim(1) = axlim(1)-1;
axlim(2) = axlim(2)+1;
axis(axlim)


