function expgui(action)
% EXPGUI  Discover e.

   x = 0:1/64:2;
   h = .0001;

   if nargin == 0
      initialize_graphics
      a = 2;
   else
      a = get_a;
   end

   % Compute y = a^x and its approximate derivative

   p = flipud(get(gca,'children'));
   y = a.^x;
   yp = (a.^(x+h) - a.^x)/h;

   % Update the plot.

   set(p(1),'ydata',y)
   set(p(2),'ydata',yp)
   set(p(3),'string',sprintf('a = %5.3f',a))

   % ----------------------------------

   function initialize_graphics
      clf
      shg
      plot(x,ones(2,length(x)));
      axis([0 2 0 8])
      set(gcf, ...
         'windowbuttondownfcn', ...
         'set(gcf,''windowbuttonmotionfcn'',''expgui(0)'')', ...
         'windowbuttonupfcn', ...
         'set(gcf,''windowbuttonmotionfcn'',[])');
      fs = get(0,'defaulttextfontsize')+2;
      text(0.3,6.0,'a = 0','fontsize',fs,'fontweight','bold')
      title('y = a^x','fontsize',fs,'fontweight','bold')
      legend('y','dy/dx','location','northwest')
      xlabel('x')
      ylabel('y')
   end

   % ----------------------------------

   function a = get_a
      point = get(gca,'currentpoint');
      xa = point(1,1);
      ya = point(1,2);
      a = ya^(1/xa);
   end

end
