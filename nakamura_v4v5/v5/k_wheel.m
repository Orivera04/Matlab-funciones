% k_wheel.m: a kickwheel game program.
% Collects coordinates from the screen; uses b-spline.
% Copyright S. Nakamura, 1995
clear; clf; hold off
axis([0, 1.25, 0,1.2 ])
text(1.02,1.14,'Click here','Color', 'r','Fontsize',10)
text(1.02,1.09,'to terminate','Color', 'r','Fontsize',10)
hold on
%axis('off')
plot([1,1.25,1.25,1,1],[1,1,1.2,1.2,1])
plot([0,1,1,0,0],[0,0,1,1,0])
text(0,1.2,'Click a number of points in the box below.','Color', 'g','Fontsize',10)
text(0,1.15,'Then click once in the small box on the right.','Color', 'g','Fontsize',10)
text(0,1.10,'Follow the instructions on the command screen','Color', 'g','Fontsize',10)
for n=1:100
[xg,yg]=ginput(1);
if xg>0.99 & yg>0.99, break; end
x(n)=xg; y(n)=yg;
text(x(n),y(n),'x')
end
%                      
m = length(y);   
xlabel('x'); ylabel('y');  plot(x,y,'o')
for k=1:m
  z=int2str(k); xk = x(k); yk=y(k); text(xk+0.1,yk,z)
end
t = 0:0.25:1; t2=t.^2; t3=t.^3;
lt = length(t); ltm=lt-1;
rs=[]; zs=[];
for i=2:m-2
   yb = 1/6*((1-t).^3*y(i-1) + (3*t3-6*t2+4)*y(i) + ...
        (-3*t3 + 3*t2 + 3*t + 1)*y(i+1) + t3*y(i+2) );
   xb = 1/6*((1-t).^3*x(i-1) + (3*t3-6*t2+4)*x(i) +  ...
        (-3*t3 + 3*t2 + 3*t + 1)*x(i+1) + t3*x(i+2) );
   plot(xb,yb)
   rs=[rs,xb(1:ltm)];
   zs=[zs,yb(1:ltm)];
end
   rs=[rs,xb(lt)];
   zs=[zs,yb(lt)];
title(' Cubic b-spline curve on x-y plane ')
fprintf('Hit RETURN to proceed\n')
pause
clf
dth=pi/10;
th=0:dth:2*pi;
for i=1:length(th)
zz(i,:)=zs;
xx(i,:)=rs.*(cos(th(i)) + 0*0.2*cos(5*th(i)));
yy(i,:)=rs.*(sin(th(i))+ 0*0.2*sin(5*th(i)));
end
surf(xx,yy,zz,zz)
colormap default
caxis([-0.5, 1.5]) 
shading interp
v=version;
if v(1)=='5', light,end
fprintf('Hit RETURN to proceed\n')
pause
surfl(xx,yy,zz,[30,30])

fprintf('Hit RETURN to proceed\n')
pause 
caxis([-1,3])
fprintf('Hit RETURN to proceed\n')
pause
clf
colormap default
[nx,ny,nz]=surfnorm(xx,yy,zz);
r=specular(nx,ny,nz,[30,30], [50,10]);
r=diffuse(nx,ny,nz, [-50,10]);
surface(xx,yy,zz,r*0.3+ 0.1*zz)
view([-30,30])
shading interp
colormap jet 
caxis([-0,1])
%print pot_cool.ps
pause
%clf

