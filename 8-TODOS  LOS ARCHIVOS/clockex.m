function clockex
% CLOCKEX Analog display clock.

clf
shg
axis([-1.1 1.1 -1.1 1.1])
axis square
axis off
x = sin(2*pi*(1:60)/60);
y = cos(2*pi*(1:60)/60);
k = 5:5:60;
line(x,y,'linestyle','none','marker','o','color','black','markersize',2)
line(x(k),y(k),'linestyle','none','marker','*','color','black','markersize',8)
h = line([0 0],[0 0],'color','blue','linewidth',4);
m = line([0 0],[0,0],'color','blue','linewidth',4);
s = line([0 0],[0 0],'color',[0 2/3 0],'linewidth',2);
gray = [.93 .93 .93];
klose = uicontrol('string','close','style','toggle');
while get(klose,'value')==0 
   c = clock;
   af = (c(2)==4 && c(3)==1);
   text(-0.4,-1.2,datestr(datenum(c(1),c(2),c(3))),'fontsize',16)
   t = c(4)/12 + c(5)/720 + c(6)/43200;
   if af, t = -t; end
   set(h,'xdata',[0 0.8*sin(2*pi*t)],'ydata',[0 0.8*cos(2*pi*t)])
   t = c(5)/60 + c(6)/3600;
   if af, t = -t; end
   set(m,'xdata',[0 sin(2*pi*t)],'ydata',[0 cos(2*pi*t)])
   k = ceil(c(6));
   if af, k = 61-k; end
   set(s,'xdata',[0 x(k)],'ydata',[0 y(k)])
   pause(1.0)
end
close(gcf)
