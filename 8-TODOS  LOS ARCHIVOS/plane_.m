% plane_ same as List_B4.
% Plots a wire frame airplane.
% Copyright S. Nakamura
set(gcf, 'NumberTitle','off','Name', 'Figure B.3; plane_ ')

clear, clf
dth=pi/16;
fuselen=6;
thf=pi:-dth:pi/2;
xa = 0:0.5:fuselen; 


 xt=fuselen+0.25:0.25:fuselen+2;
 dxt = 1.4/(length(xt)-0) ;
 yt = -1+dxt:dxt  :0.4;
length(yt);


xft=[cos(thf),xa, xt];
 
yft=[sin(thf)- 0.3*sin(2*thf).^4, ones(size(xa)), ones(size(yt))];


xfb=[cos(thf),xa,xt] ;

yfb=[-sin(thf),-ones(size(xa)),yt ];
k=length([thf, xa]);
yfb(k)=( yfb(k-1)+yfb(k+1))/2;
xc =(xfb+xft)/2;
yc = (yfb+yft)/2;
L=length(xc);
for i=1:L
if xc(i)<0
   yc(i)=0;
end
end




%plot(xfb,yfb,'y', xft,yft,'y', xc, yc,':')

%axis([-2 8 -6 6])
%pause


a=0.5;
b=0.5;

dth=pi/8;

th=0:dth:2*pi;
jmax=length(th);
xr=cos(th);

yr=sin(th);
L=length(xc);

for i=1:L
  xr=cos(th);
  yr=sin(th);
  a = (yft(i)    -yc(i))/(-yfb(i) + yc(i));
  b = (-yfb(i)    +yc(i));
  for j=1:jmax
       y(i,j)=yr(j)*b+yc(i);
       if th(j)<pi    y(i,j)=yr(j)*b*a + yc(i); end
    x(i,j)=xr(j)*b;
    z(i,j)=xc(i);
  end
end
mesh(z, x,y)

 axis([-2 8 -6 6 -6 6])
hold on
[xw,yw,zw] = wing_;
F = 1.7;
xw=F*xw; yw=F*yw; zw=F*zw;
[x1,y1,z1] = rotz_(xw,yw,zw,-90);
[x2,y2,z2] = rotx_(xw,yw,zw,180);
[x2,y2,z2] = rotz_(x2,y2,z2,-270);
mesh(x1+2,y1-0.5,z1+ 0.7);
mesh(x2+2,y2+0.5,z2+ 0.7);
mesh(0.8*x1+6.6,0.5*z1-0,-0.3*y1+1.2)
%pause
mesh(0.7*x1+6.6,0.3*y1-0.7,0.9*z1+ 0.7);
mesh(0.7*x2+6.6,0.3*y2+0.7,0.9*z2+ 0.7);
caxis([-3,1])

%[x3,y3,z3] = rotx_(x1,y1,z1,+80)

 axis([-2 8 -6 6 -6 6])



title('Commuter Airplane')
caxis([-2, 2])
colormap(hsv)





