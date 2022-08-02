function [x,y,z,t]=ropedraw(a,b,np,nt,m,x0,y0,z0)
%
% [x,y,z,t]=ropedraw(a,b,np,mp,m,x0,y0,z0)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function draws the twisted rope.
if nargin==0
  a=3; b=1; np=200; nt=25; m=6;
  x0=0; y0=0; z0=-3*pi/2;
end

% Draw the surface 
t=linspace(0,2*pi,nt); p=linspace(0,3*pi,np)';
t=repmat(t,np,1); p=repmat(p,1,nt);
xi=b*cos(t).*abs(cos(t)); eta=b*sin(t).*abs(cos(t));
rho=a+xi.*cos(m*p)+eta.*sin(m*p);
x=rho.*cos(p)+x0; y=rho.*sin(p)+y0; 
z=-xi.*sin(m*p)+eta.*cos(m*p)+p+z0;
close; surf(x,y,z,t), title('TWISTED ROPE')
xlabel('x axis'), ylabel('y axis'), zlabel('z axis')
colormap('prism(4)'), axis equal, hold on

% Fill the ends
fill3(x(1,:),y(1,:),z(1,:),'w')
fill3(x(end,:),y(end,:),z(end,:),'w') 
view([-40,10]), hold off, shg