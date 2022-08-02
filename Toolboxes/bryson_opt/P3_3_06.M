% Script p3_3_06.m; TDP for max uf with vf=0 & yf specified; finds
% p=th0 in analytic solution to satisfy terminal BC using FSOLVE;
% (u,v) in a*tf, (x,y) in a*tf^2, t in tf; m=nu_y=2tan(th0);
%                                                      2/97, 3/26/02
%
yf=.2; c=pi/180; p0=c*60; optn=optimset('Display','Iter'); N=100; 
t=[0:1/N:1]; p=fsolve('tdp_f',p0,optn,yf); [f,m]=tdp_f(p,yf);
th0=p; un=ones(1,N+1); th=atan(un*tan(th0)-m*t);
u=(1/m)*(asinh(tan(th0))-asinh(tan(th))); v=(1/m)*(sec(th0)-sec(th)); 
y=(.5/m)*(sec(th0).*t-tan(th).*v-u); x=(1/m)*(v-tan(th).*u); N1=N+1;
% 
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid
axis([0 .36 0 .27]); xlabel('x/at_f^2'); ylabel('y/at_f^2') 
%
figure(2); clf; subplot(211), plot(t,th/c); ylabel('\theta (deg)');
grid; axis([0 1 -100 100]); subplot(212), plot(t,u,t,v,'r--'); 
grid; axis([0 1 0 .8]); xlabel('t/t_f')
legend('u/at_f','v/at_f',2)

	