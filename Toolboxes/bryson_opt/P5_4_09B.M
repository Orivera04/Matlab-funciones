% Script p5_4_09b.m; cart with pendulum from y(-tf/2)=-.5 to y(tf/2)=.5
% with (th thdot ydot)=0 at both ends; ANALYTICAL SOLN using anti-symmetry
% of u, th, y;                                               4/97, 7/15/02
%
tf=[2 10 20]*pi;
for i=1:3,
 ep=.5; T=tf(i)/2; c=cos(T); s=sin(T);
 M=[T -T*c/2 s; 1 (-c+T*s)/2  c; (1-ep)*T^3/3 ...
   (1-ep/2)*(s-T*c)-ep*(s-T*c-T^2*s)/2  ep*(T*c-s)];
 b=[0 0 .5]'; A=M\b; A1=A(1); A2=A(2); A3=A(3);
 t=T*[-1:.02:1]; un=ones(1,101); st=sin(t); ct=cos(t);
 u=-A1*t-A2*st;  th=A1*t-A2*t.*ct/2+A3*st;
 y=-.5*un+(A1/2)*(1-ep)*(T^2*(t+T*un)-(t.^3+T^3*un)/3)...
   +A2*((1-ep/2)*(st+s*un-c*(t+T*un))-ep*(-T*s*(t+T*un)...
   +st-t.*ct+(s-T*c)*un)/2)+A3*ep*(c*(t+T*un)-st-s*un);
 %
 t=t/tf(i); figure(i); clf; subplot(211), plot(t,y); grid; ylabel('y') 
 axis([-.5 .5 -.5 .5]); subplot(212), plot(t,th,t,u,'r--'); grid 
 xlabel('t/t_f'); legend('u','\theta')
end

