function flame
% FLAME  A stiff ordinary differential equation.
% A ball of fire grows until its radius is just large enough that all of
% the oxygen available through the surface is consumed by combustion in
% the interior.  The equation for the radius is rdot = r^2 - r^3.
% The problem becomes stiff as the radius approaches its limiting value.

shg
set(gcf,'double','on','color','black')
set(gca,'color','black')
m = 30;
[rho,theta] = ndgrid((0:m)'/m, pi*(-m:m)/m);
x = rho.*sin(theta);
y = rho.*cos(theta);
r0 = .02;
t = (0:.002:2)/r0;
[t,r] = ode23s(inline('r.^2-r.^3','t','r'),t,r0,odeset('reltol',1.e-5));
z = 1-rho/r0;
p = pcolor(x,y,z);
shading interp
colormap(hot)
axis square
axis off
s = title(sprintf('t = %8.2f   r = %10.6f',0,r0),'fontsize',16);
set(s,'color','white');
for k = 1:length(t);
   z = max(0,1-rho/r(k));
   set(p,'cdata',z)
   set(s,'string',sprintf('t = %8.1f   r = %10.6f',t(k),r(k)));
   drawnow
end
uicontrol('string','close','callback','close(gcf)')
