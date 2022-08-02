% f5_14 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 5.14')

clear,clf
dth=pi/20;
th=0:dth:2*pi;
x=cos(th);
y=sin(th);
z=zeros(size(x));
 
axis([-1.5,1.5,-1.5,1.5,-0,2])
hold on
for j=1:4
if j==1
xc(j,:)=zeros(size(x));
yc(j,:)=zeros(size(x));
zc(j,:)=0.5*ones(size(x));

else
xc(j,:)=x;
yc(j,:)=y;
zc(j,:)=z;
end
end
zc(2,:)=x+1;
zc(3,:)=x+1;

[nx,ny,nz]=surfnorm(xc,yc,zc);
r=specular(nx,ny,nz, [1,-1,1],[ -2,1,5]);
%surf(xc,yc,zc,r);colormap(hot)
surfl(xc,yc,zc,[100,0] );%colormap(gray)
%mesh(xc,yc,zc);
%plot3(x,y,z)
% plot3(x,y,x+1)
%xlabel('x')
%ylabel('y')
 plot3([1,2],[0,0],[0,0])
 plot3([1,2],[0,0],[2,2])
 plot3([1.7,1.7],[0,0],[2,1.5],':')
 plot3([1.7,1.7],[0,0],[0.5,0],':')
 text(1.6,0,1,'H=1m','FontSize',[24])
 
 plot3([-1,-1],[0,-2],[0,0])
  plot3([1,1],[0,-2],[0,0])
  plot3([-1,-0.5],[-1.7,-1.7],[0,0],':')
  plot3([0.5,1],[-1.7,-1.7],[0,0],':')
   text( -0.3 , -1.7  ,0,'D=1m','FontSize',[18])
 axis('off')
view(-30,30)
% plot3(x*1.02,y*1.02,z) 
shading interp
colormap(hot)
%print prob5_14fig.ps








