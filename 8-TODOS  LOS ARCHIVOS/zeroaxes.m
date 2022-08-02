function zeroaxes

% ZEROAXES Redraws the axes at the zero values.
% See also: CENTAXES
% Andrew Knight

% Modified February 1994 to omit the zero label if necessary.

holdwason = ishold;
axesin = get(gcf,'CurrentAxes');
pos = get(axesin,'position');
ax  = axis;
xscale = get(axesin,'XScale');
yscale = get(axesin,'YScale');
set(axesin,'visible','off')

xmin = ax(1);
xmax = ax(2);
ymin = ax(3);
ymax = ax(4);

ticklength  = get(axesin,'TickLength');
XAxisHeight = ticklength(1);
YAxisWidth  = ticklength(1);

f   = polyfit([ax(1) ax(2)],[pos(1) pos(1)+pos(3)],1);
XAxisXLimits = polyval(f,[xmin xmax]);
YAxisXLimits = polyval(f,[0 YAxisWidth*abs(xmax - xmin)]);

f   = polyfit([ax(3) ax(4)],[pos(2) pos(2)+pos(4)],1);
YAxisYLimits = polyval(f,[ymin ymax]);
XAxisYLimits = polyval(f,[0 XAxisHeight*abs(ymax - ymin)]);


XAxisPosition = [XAxisXLimits(1) 
                 XAxisYLimits(1)
		 XAxisXLimits(2) - XAxisXLimits(1)
		 XAxisYLimits(2) - XAxisYLimits(1)];

bgcolour = get(gcf,'color');
	     
hX = axes('position',XAxisPosition,...
    'XLim',[xmin xmax],...
    'box','off',...
    'YTick',[],...
    'TickDir','out',...
    'XScale',xscale,...
    'YColor',bgcolour,...
    'color','none');


YAxisPosition = [YAxisXLimits(1) 
                 YAxisYLimits(1)
		 YAxisXLimits(2) - YAxisXLimits(1)
		 YAxisYLimits(2) - YAxisYLimits(1)];
	     
hY = axes('position',YAxisPosition,...
    'YLim',[ymin ymax],...
    'box','off',...
    'xtick',[],...
    'TickDir','out',...
    'YScale',yscale,...
    'XColor',bgcolour,...
    'color','none');

% Get rid of the zero ticks if necessary:

if ymin<0 & ~strcmp(xscale,'log')
  xticks = get(hX,'XTick');
  xticks(xticks==0) = [];
  set(hX,'XTick',xticks)
end
  
if xmin<0 & ~strcmp(yscale,'log')
  yticks = get(hY,'YTick');
  yticks(yticks==0) = [];
  set(hY,'YTick',yticks)
end
  
set(gcf,'CurrentAxes',axesin)

if ~holdwason
  set(hX,'NextPlot','Replace')
  set(hY,'NextPlot','Replace')
end
