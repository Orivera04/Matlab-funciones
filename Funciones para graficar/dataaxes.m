function [xaxes,yaxes] = dataaxes

% DATAAXES Changes the appearance of the current plot by truncating the axes
% at the data limits.

holdwason = ishold;

axesin = get(gcf,'CurrentAxes');
pos = get(axesin,'position');
ax  = axis;
set(axesin,'visible','off')

h = get(axesin,'children');
xmin = 1e99;
xmax = -1e99;
ymin = xmin;
ymax = xmax;
for i=1:length(h)
  ChildType = get(h(i),'type');
  if ~strcmp(ChildType,'text')
    XData = get(h(i),'xdata');
    xmin = min(xmin,min(min(XData)));
    xmax = max(xmax,max(max(XData)));
    
    YData = get(h(i),'ydata');
    ymin = min(ymin,min(min(YData)));
    ymax = max(ymax,max(max(YData)));
  end
end

f   = polyfit([ax(1) ax(2)],[pos(1) pos(1)+pos(3)],1);
XScreenLimits = polyval(f,[xmin xmax]);
f   = polyfit([ax(3) ax(4)],[pos(2) pos(2)+pos(4)],1);
YScreenLimits = polyval(f,[ymin ymax]);

ticklength  = get(axesin,'TickLength');
XAxisHeight = ticklength(1);
YAxisWidth  = ticklength(1);

XAxisPosition = [XScreenLimits(1)                    pos(2) ...
	         XScreenLimits(2)-XScreenLimits(1)   XAxisHeight];
XTicks = get(axesin,'xtick');
%XTicks(1) = xmin;
%XTicks(length(XTicks)) = xmax;

bgcol = get(gcf,'color');
xaxes = axes('position',XAxisPosition,'XLim',[xmin xmax],...
    'box','off','xtick',XTicks,'YTick',[],'ycol',bgcol);

YTicks = get(axesin,'ytick');
%YTicks(1) = ymin;
%YTicks(length(YTicks)) = ymax;
YAxisPosition = [pos(1)     YScreenLimits(1) ...
	         YAxisWidth YScreenLimits(2)-YScreenLimits(1)];
yaxes = axes('position',YAxisPosition,'YLim',[ymin ymax],...
    'box','off','xtick',[],'YTick',YTicks,'xcol',bgcol);

set(gcf,'CurrentAxes',axesin)

if ~holdwason
  hold off
end


