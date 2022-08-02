% Script f05_08.m min integral-square control of triple-
% integrator plant; semi-analytical solution; interpolated
% tf to change position by one unit with |u(t)| < 1; 
%                                             2/94, 4/3/02

T=3.915; xf=[-1 0 0]'; M=zeros(3);
M(1,:)=[-T^3/6 -T^4/24 -T^5/60];
M(2,:)=[ T^2/2  T^3/6   T^4/12];
M(3,:)=[-T     -T^2/2  -T^3/3];
A=M\xf;

for i=1:101, t=T*(i-1)/100; 
  u(i)=[1 t t^2]*A;
  a(i)=[t t^2/2 t^3/3]*A;
  v(i)=[t^2/2 t^3/6 t^4/12]*A;
  y(i)=[t^3/6 t^4/24 t^5/60]*A-1;
  t1(i)=t; end

t1=t1/T; figure(1); clf; subplot(211), plot(t1,y); grid
axis([0 1 -1 0]); text(.2,-.5,'Position y')
subplot(212), plot(t1,u,t1,a); grid; axis([0 1 -.5 1]) 
xlabel('t/tf'); text(.09,-.3,'Control u')
text(.3,.5,'Acceleration a')
%print -deps2 f05_08
