% Newt_g(f_name, x0, xmin, xmax, n_points)
% finds a root of a function by
% newton iteration (with graphics)
% Copyright S. Nakamura, 1995
function x = Newt_gr(f_name, x0, xmin, xmax, n_points)
clg, hold off
% xmin, xmax:  min and max for plotting
del_x=0.001;
wid_x = xmax - xmin;  dx = (xmax- xmin)/n_points;
xp=xmin:dx:xmax;   yp=feval(f_name, xp);
plot(xp,yp); xlabel('x');ylabel('f(x)');
title('Newton Iteration'),hold on
f_name
ymin=min(yp); ymax=max(yp);wid_y = ymax-ymin;
yp=0.*xp;  plot(xp,yp)
x = x0;   xb=x+999; n=0;
while abs(x-xb)>0.000001
   if n>300 break; end
   y=feval(f_name, x);    
      plot([x,x],[y,0],'--'); 
      plot(x,0,'o')
   fprintf(' n=%3.0f,  x=%12.5e,  y=%12.5e\n', n,x,y);
   xsc=(x-xmin)/wid_x;
   if n<4, 
      text(x, -wid_y/20, [ num2str(n)], 'FontSize', [16]), 
   end
   y_driv=(feval(f_name, x+del_x) - y)/del_x;
   xb=x;
   x = xb - y/y_driv; n=n+1;
   plot([xb,x],[y,0],':')
end
plot([x x],[0.02*wid_y 0.2*wid_y])
text( x, 0.25*wid_y, 'Final solution','FontSize', [16])
plot([x (x-wid_x*0.004)],[0.02*wid_y  0.05*wid_y])
plot([x (x+wid_x*0.004)],[0.02*wid_y  0.05*wid_y])
axis([xmin,xmax,ymin*1.2,ymax*1.2])
