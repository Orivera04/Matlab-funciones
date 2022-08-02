% Script p4_4_09.m; TDP for min tf with gravity, to vf=0, (vf,yf)
% specified; finds p=th0 in analytic soln. to satisfy y(tf)=yf using
% FSOLVE; t in uf/a, (u,v) in uf, (x,y) in uf^2/a, g in a; 
%                                                      2/97, 3/29/02
%
c=pi/180; yf=.2/.4935^2; g=1/3; p0=c*80; 
optn=optimset('Display','Iter','MaxIter',100); 
p=fsolve('tdpgt_f',p0,optn,yf,g); [f,m,tf]=tdpgt_f(p,yf,g);
%
th0=p(1); t=tf*[0:.01:1]; N=101; un=ones(1,N);
th=atan(un*tan(th0)-m*t); u=(1/m)*(asinh(tan(th0))-asinh(tan(th)));
vb=(1/m)*(sec(th0)-sec(th)); v=vb-g*t; 
yb=(.5/m)*(sec(th0)*t-tan(th).*vb-u); 
y=yb-g*t.^2/2; x=(1/m)*(vb-tan(th).*u);
% 
figure(1); clf; plot(x,y,x(N),y(N),'ro',0,0,'ro'); grid 
axis([-.1 1.1 0 .9]); xlabel('ax/u_f^2'); ylabel('ay/u_f^2') 
%
figure(2); clf; subplot(211), plot(t,th/c); grid
ylabel('\theta (deg)'); axis([0 2.1 -100 100]) 
subplot(212), plot(t,u,t,v,'r--'); grid; axis([0 2.1 0 1])
xlabel('at/u_f'); legend('u/u_f','v/u_f',2)

	