function newton_pendulum
% Simulation of the Newton Pendulum
% Gerd.Steinebach@fh-brs.de               6.12.2005
%
clear;
%------------- initial conditions, tend: may be altered
IC=[-pi/2, -pi/2, 0, 0, 0]; tend=2.0;
%-------------
global l d 
l=0.14; d=0.02;
%
t0=0.0; 
y0=[IC(1),0,IC(2),0,IC(3),0,IC(4),0,IC(5),0];
options = odeset('RelTol',1.e-10,'AbsTol',1.e-10,'Events',@events,'MaxStep',0.01);

T=t0; Y=y0; tstop=t0;

while t0<tend
  [t,y,te,ye,ie]=ode45(@pendel5,[t0,tend],y0,options);
  if (length(te)>0) && (te(1)-t0<1.e-14)                   % event in beginning
    jevent=ie(1);
    v1=y0(2*jevent); v2=y0(2*jevent+2);
    y0(2*jevent)=v2; y0(2*jevent+2)=v1;
  else  
    t0=t(end);  y0=y(end,:); tstop=[tstop;t0];
    n=length(ie);
    for i=1:n
      jevent=ie(i);
      v1=y0(2*jevent); v2=y0(2*jevent+2);
      y0(2*jevent)=v2; y0(2*jevent+2)=v1;
    end  
    for i=1:n                     % once again
      jevent=ie(i);
      v1=y0(2*jevent); v2=y0(2*jevent+2);
      if (v1>v2) 
        y0(2*jevent)=v2; y0(2*jevent+2)=v1;
      end  
    end  
    T=[T;t];Y=[Y;y];
  end  
end

plot_pendel(T,Y);

function [value,isterminal,direction]=events(t,Y)
% Eventfunction stops integration if collision is detected
global l d 
%
isterminal=[1;1;1;1];     % stop Simulation
direction=[-1;-1;-1;-1];  % if event-Function is decreasing
x1=l*sin(Y(1));      y1=-l*cos(Y(1));
x2=l*sin(Y(3))+d;   y2=-l*cos(Y(3));
x3=l*sin(Y(5))+2*d; y3=-l*cos(Y(5));
x4=l*sin(Y(7))+3*d; y4=-l*cos(Y(7));
x5=l*sin(Y(9))+4*d; y5=-l*cos(Y(9));
value=[(x1-x2)^2 + (y1-y2)^2 - d^2;...
       (x2-x3)^2 + (y2-y3)^2 - d^2;...
       (x3-x4)^2 + (y3-y4)^2 - d^2;...
       (x4-x5)^2 + (y4-y5)^2 - d^2];
d1=1.0e-6;value=value+[d1;d1;d1;d1];


function dy=pendel5(t,y)
% 5 Kugeln
global l d 
  g=9.81; m=0.045;  fr=0.01;
  dy=zeros(10,1);
  dy(1)=y(2);
  dy(2)=-g.*sin(y(1))./l-fr*y(2)/m;
  dy(3)=y(4);
  dy(4)=-g.*sin(y(3))./l-fr*y(4)/m;
  dy(5)=y(6);
  dy(6)=-g.*sin(y(5))./l-fr*y(6)/m;
  dy(7)=y(8);
  dy(8)=-g.*sin(y(7))./l-fr*y(8)/m;
  dy(9)=y(10);
  dy(10)=-g.*sin(y(9))./l-fr*y(10)/m;

function plot_pendel(t,y)
%
global l d 
%
[nt,np]=size(y); np=np/2;
x0=zeros(nt,np); y0=zeros(nt,np); x1=zeros(nt,np); y1=zeros(nt,np); 
for i=1:np
  ip=2*i-1;
  x1(:,i)=l*sin(y(:,ip)); y1(:,i)=-l*cos(y(:,ip));
  x0(:,i)=x0(:,i)+(i-1)*d;  x1(:,i)=x1(:,i)+(i-1)*d;
end
%
p=plot(0,0); 
axis([-1.2*l 1.2*l+np*d -1.2*l 0]); axis equal
for i=1:np
  line_handle(i)=line([x0(1,1) x1(1,1)],[y0(1,1) y1(1,1)]);
  circle_handle(i)=line([x0(1,1) x1(1,1)],[y0(1,1) y1(1,1)]);
  set(line_handle(i),'erasemode','xor');
  set(circle_handle(i),'erasemode','xor');
end
%
for i=1:nt
  for j=1:np
    set(line_handle(j),'xdata',[x0(i,j) x1(i,j)],'ydata',[y0(i,j) y1(i,j)]);
    plot_circle(circle_handle(j),x1(i,j),y1(i,j),d/2);
  end  
  drawnow
end

function plot_circle(handle,x0,y0,r)
% plot circle
omega=linspace(0,2*pi,100);
x=x0+r*sin(omega); y=y0+r*cos(omega);
set(handle,'xdata',x,'ydata',y);
