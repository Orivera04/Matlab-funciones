function boxplotterv(params,outsideValues,names)
%  make box or whisker plots with vertical boxes
%  boxplotterv(params,outliers,names)
%  params from boxparams.m
%  outsideValues from boxparams.m
%  names of the data series

%  See also boxplotter.m

% Copyright (c) 2000 by Datatool
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
plot(1:nb,params(:,3),'.','MarkerSize',18)
%  uses names for labels
set(gca,'XTick',1:nb)
set(gca,'XLim',[0 nb+1])
set(gca,'XTickLabel',char(names))

hold on
%  plot quartiles as box
for ii = 1:nb
   temp1 = params(ii,2);
   temp2 = params(ii,4);
   yy = [temp1 temp1 temp2 temp2 temp1];
   xx = [ii-hw ii+hw ii+hw ii-hw ii-hw];
   plot(xx,yy,'-')
end
%  plot adjacent values
for ii = 1:nb
   plot([ii ii],[params(ii,1) params(ii,2)],'--')
   plot([ii ii],[params(ii,4) params(ii,5)],'--')
   plot([ii-hw ii+hw],[params(ii,1) params(ii,1)],'--')
   plot([ii-hw ii+hw],[params(ii,5) params(ii,5)],'--')
end
%  plot outside values
if exist('outsideValues')
   plot(outsideValues(:,1),outsideValues(:,2),'o')
end
hold off

%  make some extra space
axlim = axis;
axlim(3) = axlim(3)-1;
axlim(4) = axlim(4)+1;
axis(axlim)


