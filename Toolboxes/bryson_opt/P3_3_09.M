% Script p3_3_09.m; TDP for max uf with gravity to vf=0 and spec.(tf,yf);
% finds p=th0 in analytic soln. to satisfy y(tf)=yf using FSOLVE; t in tf,
% (u,v) in a*tf, (x,y) in a*tf^2, g in a;                    2/97, 3/26/02
%
c=pi/180; yf=.2; g=1/3; p0=c*80; optn=optimset('Display','Iter');
p=fsolve('tdpg_f',p0,optn,yf,g); [f,m]=tdpg_f(p,yf,g);
%
th0=p; t=[0:.01:1]; N=101; un=ones(1,N); th=atan(un*tan(th0)-m*t);
u=(1/m)*(asinh(tan(th0))-asinh(tan(th))); vb=(1/m)*(sec(th0)-sec(th));
v=vb-g*t; y=(.5/m)*(sec(th0)*t-tan(th).*vb-u)-g*t.^2/2;
x=(1/m)*(vb-tan(th).*u);
% 
figure(1); clf; plot(x,y,x(N),y(N),'ro',0,0,'ro'); grid;
axis([-.03 .25 0 .21]); xlabel('x/at_f^2');  ylabel('y/at_f^2'); 
%
figure(2); clf; subplot(211), plot(t,th/c); grid; ylabel('\beta (deg)');
axis([0 1 -100 100]); subplot(212), plot(t,u,t,v,'r--'); grid;
axis([0 1 0 .6]); xlabel('t/t_f'); legend('u/at_f','v/at_f',2);

	