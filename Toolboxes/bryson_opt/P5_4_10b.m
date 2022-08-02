% Script p5_4_10b.m; HTC of cart with inverted pendulum from rest at
% t=-tf/2 to rest at t=tf/2 displaced by unit distance; semi-analytical
% soln using anti-symmetry  of u, th, y about t=0;         7/97,7/15/02
%
tf=30; T=tf/2; ep=.5; sh=sinh(T); ch=cosh(T);  
M=[-T T*ch/2 sh 0; -1 (ch+T*sh)/2 ch 0;...
   -(1-ep)*T^2/2 -(1-ep/2)*ch-ep*T*sh/2 -ep*ch 1;...
   -(1-ep)*T^3/6   -(1-ep)*sh-ep*T*ch/2 -ep*sh T]; 
c=[0 0 0 .5]'; A=M\c;
for i=1:101, x=T*(i-1)/100; a=sinh(x); b=cosh(x);
 u(i)=[-x -a 0 0]*A; th(i)=[-x x*b/2 a 0]*A;
 y(i)=[-(1-ep)*x^3/6 -(1-ep)*a-ep*x*b/2 -ep*a x]*A; t(i)=x;
end; t=t/tf;
%
figure(1); clf; subplot(211), plot(t,y,-t,-y); grid
ylabel('Cart Position y') 
subplot(212), plot(t,th,t,u,'-',-t,-th,-t,-u,'-'); grid
xlabel('t/t_f'); legend('Force u','Angle \theta');
	
