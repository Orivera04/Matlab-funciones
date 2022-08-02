% Script p4_4_10.m; TDP for min tf to vf=0 with gravity and spec.
% (uf,yf,xf); finds p=(thb0,thbf) in analytic solution to match BCs
% using FSOLVE; (u,v) in uf, (x,y) in uf^2/a, t in uf/a, g in a;
%                                                    2/97, 3/29/02
%
xf=.15/.4577^2; yf=.2/.4577^2; g=1/3; c=pi/180; p0=c*[78 -72];
optn=optimset('Display','Iter','MaxIter',100);  
p=fsolve('tdpgxt_f',p0,optn,yf,xf,g);
[f,tf,m,al]=tdpgxt_f(p,yf,xf,g); N=100; b0=p(1); t=tf*[0:1/N:1];
un=ones(1,N+1); b=atan(un*tan(b0)-m*t);  
ub=(1/m)*(asinh(tan(b0))-asinh(tan(b))); vb=(1/m)*(sec(b0)-sec(b));
xb=(1/m)*(vb-tan(b).*ub); yb=(.5/m)*(sec(b0)*t-tan(b).*vb-ub);
u=ub*cos(al)-vb*sin(al); v=ub*sin(al)+vb*cos(al)-g*t;
x=xb*cos(al)-yb*sin(al); y=xb*sin(al)+yb*cos(al)-g*t.^2/2;
th=b+al*un;
%
figure(1); clf; plot(x,y,xf,yf,'ro',0,0,'ro'); grid;
axis([-.2 1.13 0 1]); xlabel('ax/u_f^2'); ylabel('ay/u_f^2');
%
figure(2); clf; subplot(211), plot(t,th/c); grid; 
ylabel('\theta (deg)'); axis([0 2.3 -100 100]); subplot(212),
plot(t,u,t,v,'r--'); grid; xlabel('at/uf'); 
legend('u/u_f','v/u_f',2); axis([0 2.3 -.1 1]); 
	 
	