% f2_22 
% view_Point_fig.m

close, clear, clg
set(gcf, 'NumberTitle','off','Name', 'Figure 2.22')
axis([-1,2,-1,2,-0,2])
axis('square')
hold on
x=[0,3];
y=[0,0];
z=[0,0];     
plot3(x,y,z);
text(3.2,0,0,'X')
x=[0,0];
y=[0,3];
z=[0,0];     

plot3(x,y,z);
plot3(x,-y,z, '--');

text(0, 3.4,0,'Y')
text(0, -3.4,0.1,'(reference angle)')
text(0, -3.4,+0.3,'az=0, el=0 ')
text(1, -1.9,+0.3,'az-angle ')
text(1.5, -0.4,+1.2,'el-angle ')


x=[0,0];
y=[0,0];
z=[0,3];     


plot3(x,y,z);

%xlabel('x');
%ylabel('y');
%zlabel('z');
text(-0.2,0, 2.4,'Z')
tha=0.5*pi/3;
dth=tha/10;
th=-pi/2:dth:tha;
r=1.5;
xr=cos(th);
yr=sin(th);
zr=zeros(size(xr));
plot3(xr,yr,zr,'.');

plot3([0,cos(tha)*r], [0,sin(tha)*r],[ 0,0] ,'--')
phi=0.8*pi/2;
r2=r*1.5;
plot3([0,cos(tha)*r2*cos(phi)], [0,sin(tha)*r2*cos(phi)],[ 0,sin(phi)*r2] ,'--')
text(cos(tha)*r2*cos(phi), sin(tha)*r2*cos(phi), sin(phi)*r2+0.7, 'Viewer  at (az, el) angle ')
text(cos(tha)*r2*cos(phi), sin(tha)*r2*cos(phi), sin(phi)*r2+0.55, 'looking at origin')
x0=cos(tha)*r2*cos(phi); y0= sin(tha)*r2*cos(phi)+0.1; z0= sin(phi)*r2+0.1;

two_eyes(190,-45,x0,y0,z0,0.3)


%text(cos(tha)*r2*cos(phi)-0.1, sin(tha)*r2*cos(phi), sin(phi)*r2, 'O')
%text(cos(tha)*r2*cos(phi)-0.1, sin(tha)*r2*cos(phi), sin(phi)*r2, 'o')
dphi=phi/30;
phip=0:dphi:phi;
xp = cos(tha)*r2*cos(phip)*0.5;
yp=sin(tha)*r2*cos(phip)*0.5;
zp=sin(phip)*r2*0.5;
plot3(xp,yp,zp,'.')
axis('off')

view(40,30)
%view(-30,30)
%print view_Point_fig.ps
