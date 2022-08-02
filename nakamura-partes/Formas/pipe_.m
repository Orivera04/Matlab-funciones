% pipe_ same as List_B2: plots a spiral pipe
% Copyright S. Nakamura
set(gcf, 'NumberTitle','off','Name', 'Figure B.2; pipe_ ')

clear,clf,hold off
%------------Construction of pipe cross section (circle)
dth=pi/10;
th=0:dth:2*pi;
x=0.25*cos(th);y=0.25*sin(th);z=0.25*zeros(size(x));
%------------Spiral shape of axis of pipe
ths=0:dth:pi*3.5;
xs=2*cos(ths);ys=2*sin(ths);zs=zeros(size(xs))+ 0.3*ths ;
m=length(xs) ;
%------------Construction of pipe section to axial direction
for i=2:m
  xn=xs(i)-xs(i-1) ;
  yn=ys(i)-ys(i-1) ;
  zn=zs(i)-zs(i-1) ;
  rn=sqrt(xn^2+yn^2+zn^2);
  el=acos(zn/rn)*180/pi;
  az=0;
  rxy=sqrt(xn^2+yn^2);
  if xn==0, xn=1e-10;end
  az=atan2(yn,xn)*180/pi;
  [xd,yd,zd]=rotx_(x ,y ,z ,-el);
  b=(az+90);
  [xp(i,:),yp(i,:),zp(i,:)]=rotz_(xd,yd,zd,b);
  xp(i,:)=xp(i,:)+xs(i);
  yp(i,:)=yp(i,:)+ys(i);
  zp(i,:)=zp(i,:)+zs(i);
end
%------------- Pipe structure is now in xpp,ypp,zpp
xav=sum(xp(2,:))/length(xp(2,:));
yav=sum(yp(2,:))/length(yp(2,:));
zav=sum(zp(2,:))/length(zp(2,:));
xp(1,:)=xav*0.2+ xp(2,:)*0.8;
yp(1,:)=yav*0.2+ yp(2,:)*0.8;
zp(1,:)=zav*0.2+ zp(2,:)*0.8;
j=m-1;
xav=sum(xp(j,:))/length(xp(j,:));
yav=sum(yp(j,:))/length(yp(j,:));
zav=sum(zp(j,:))/length(zp(j,:));
xp(m,:)=xav*0.2+ xp(j,:)*0.8;
yp(m,:)=yav*0.2+ yp(j,:)*0.8;
zp(m,:)=zav*0.2+ zp(j,:)*0.8;

xpp=xp;
ypp=yp;
zpp=zp;
%-------------------------------------
colormap hsv
mesh(xpp,ypp,zpp)
view([70,30])
axis([-2.5 ,2.5 ,-2.5 ,2.5 ,-.5,3.5])
title('Plot by "mesh" with "colormap hsv" ')



