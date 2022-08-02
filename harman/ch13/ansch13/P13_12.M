% P13_12 Vibrating string wave equation d^2u(t)/dt^2=c^2*d^2u(x)/dx^2
%  with c=100m/s the wave speed and L=2m the length of the string.
%  Assume u(0,t)=0, u(L,t)=0, du/dt(x,0)=0, u(x,0)=f(x)  
%
%  Thus, solution is sum[bn*cos(n*pi*c*t/L)*sin(n*pi*x/L)]
%    with the coefficients
%     u(x,0)=sum[bn*sin(n*pi*x/L)=f(x),  f(x) is a triangle shape
%  Solving for bn yields
%    bn=[0.8/(pi^2*n^2)]*sin(n*pi/2)
%  Uses gtext to annotate plots
clear
fprintf('Use cursor and mouse to annotate each solution\n')
L=2;
c=100;
t=[0 .008 .016 .02]  % Time points for plotting
Deltax=L/100;         % Points in x
x=0:Deltax:L;
%
nterms=10;
sizet=length(t);
fn=zeros(length(t),length(x));
for I=1:sizet 
I
% 
 for n=1:nterms
  fn(I,:)=fn(I,:)+(0.8/pi^2)*(1/n^2)*sin(n*pi/2)*cos(n*pi*c*t(I)/2)*sin(n*pi*x/2);
 end				
end
%
clf
plot(x,fn(1,:))
gtext('t=0.0')
hold on
plot(x,fn(2,:))
gtext('t=0.008')
plot(x,fn(3,:))
gtext('t=0.016')
plot(x,fn(4,:))
gtext('t=0.2')
hold off
%
% Version 5: Added fprintf
