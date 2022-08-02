function dotplot(params,names)
%  make a dot plot
%  dotplot(params,names)
%  params is a vector of values to plot
%  names to use as data labels

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

nb = length(params);

%  if names are not given, make some
if nargin<2
   for ii = 1:nb
      names{ii} = ['Series' int2str(ii)];
   end
end

%  plot values
plot(params,1:nb,'.','MarkerSize',18)
%  uses names for labels
set(gca,'YTick',1:nb)
set(gca,'YLim',[0 nb+1])
if ~isempty(names)
   set(gca,'YTickLabel',char(names))
end
set(gca,'YDir','reverse')

%  use axis limits a bit beyond data
pmin = 0.99*min(params);
pmax = 1.01*max(params);
hold on
%  plot dotted lines
for ii = 1:nb
   plot([pmin pmax],[ii ii],':')
end
hold off


