function clockex
% CLOCKEX Analog display clock.


p = init_graphics;
while get(p.stop,'value')==0 
   c = clock;
   set(p.date,'string',datestr(datenum(c(1),c(2),c(3))))
   s = ceil(c(6));
   m = c(5) + s/60;
   h = c(4) + m/60;
   set(p.sec,'xdata',[0 p.x(s)],'ydata',[0 p.y(s)])
   set(p.min,'xdata',[0 sin(2*pi*m/60)],'ydata',[0 cos(2*pi*m/60)])
   set(p.hour,'xdata',[0 0.8*sin(2*pi*h/12)],'ydata',[0 0.8*cos(2*pi*h/12)])
   pause(1.0)
end
close(gcf)

% ------------------------------------

function p = init_graphics
   clf
   shg
   axis([-1.1 1.1 -1.1 1.1])
   axis square off
   p.x = sin(2*pi*(1:60)/60);
   p.y = cos(2*pi*(1:60)/60);
   line(p.x,p.y,'linestyle','none','marker','o', ...
      'color','black','markersize',2)
   k = 5:5:60;
   line(p.x(k),p.y(k),'linestyle','none','marker','*', ...
      'color','black','markersize',8)
   p.sec = line([0 0],[0 0],'color',[0 2/3 0],'linewidth',2);
   p.min = line([0 0],[0,0],'color','blue','linewidth',4);
   p.hour = line([0 0],[0 0],'color','blue','linewidth',4);
   p.date = text(-0.4,-1.2,'xxx','fontsize',16);
   p.stop = uicontrol('string','close','style','toggle');
end

end %clockex
