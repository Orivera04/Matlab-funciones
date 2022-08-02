% two-eyes(phi,eyeangle, x0,y0,z0,width) draws two eyes 
% as illustrated in Figures 2.22 and 2.23.    
%  phi : direction angle of face (degree) 
%        If 0 the face is on the x-z plane toward positive y.
%  eyeangle:  direction of eye balls.  Degree.
%  x0,y0,z0: 3D coordinates for the eyes
% Example>>
%        clg;hold on; Two_eyes(120,45,0,0,0,0.2);view(120,30)
%        axis([-1 1 -1 1 -1 1]); ylabel('y'); hold off
% Copyright S. Nakamura, 1995
function f=two_eyes(phi,eyeangle, x0,y0,z0,width)
eyr = 0.2;     
angle0=eyeangle;
x=[-1,0,1,0,-1]; z=[0, 0.3,0,-0.3, 0]; y=[0,0,0,0,0];
dth=pi/10;  th=0:dth:2*pi;
zc=cos(th)*eyr; xc=sin(th)*eyr; yc=zeros(size(xc));
th=0:dth:10*pi;
ze=cos(th)*eyr.*(1.0- 0.03*th);    %eye ball
xe=sin(th)*eyr.*(1.0- 0.03*th);
angle = angle0/180*pi;
xd=xe/2 + eyr*cos(angle)/2;
zd=ze/2 + eyr*sin(angle)/2;
b = eyr^2 - xd.^2 - zd.^2;
yd=sqrt((eyr+0.01)^2 - xd.^2 - zd.^2);
xcL=xc-0.25; xcR=xc+0.25;
yc=yc;  zc=zc;
xdL=xd-0.25;  xdR=xd+0.25;
yd=yd*0.2; zd=zd;  xdR=xd+0.25;
xns=[0,0,0];  yns=[0, 0.1,0];  zns=[0.1,-0.3,-0.3]; % nose
S=width/0.2/2;  %scale factor
[x1,y1,z1]=rotz_(xcL,yc,zc, phi);
plot3(x1*S+x0,y1*S+y0,z1*S+z0);
[x2,y2,z2]=rotz_(xcR,yc,zc, phi);
plot3(x2*S+x0,y2*S+y0,z2*S+z0);
[x3,y3,z3]=rotz_(xdL,yd,zd, phi);
plot3(x3*S+x0,y3*S+y0,z3*S+z0);
[x4,y4,z4]=rotz_(xdR,yd,zd, phi);
plot3(x4*S+x0,y4*S+y0,z4*S+z0);
[x5,y5,z5]=rotz_(xns,yns,zns, phi);
plot3(x5*S+x0,y5*S+y0,z5*S+z0);
axis('off')
