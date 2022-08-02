% BARGRID.M Put grid on plot a la Tufte's white grid.

% A. Knight, May 1997

% Assume we have a vertical bar plot and we want horizontal grid lines drawn
% the same color as the background.

xt = get(gca,'xtick');
yt = get(gca,'ytick');
[xx,yy]=meshgrid([0 6],yt);

hold on
h = plot(xx',yy');
lw = get(gcf,'DefaultAxesLineWidth');
set(h,'color',get(gcf,'color'),'linewidth',lw)