% Script p3_3_10.m; TDP for max uf with gravity and spec. (tf,vf,xf,yf);
% finds p=(thb0,thbf) in analytic solution to satisfy terminal BCs using
% FSOLVE; (u,v) in a*tf, (x,y) in a*tf^2, g in a, t in tf; 2/97, 6/12/98
%
c=pi/180; yf=.2; xf=.15; g=1/3; p0=c*[78 -72]; 
optn=optimset('Display','Iter');
p=fsolve('tdpgx_f',p0,optn,yf,xf,g); [f,m,al]=tdpgx_f(p,yf,xf,g);
%
b0=p(1); N=101; un=ones(1,N); t=[0:.01:1]; b=atan(un*tan(b0)-m*t);
fu=asinh(tan(b0))-asinh(tan(b)); fv=sec(b0)-sec(b); fx=fv-tan(b).*fu;
fy=(m*sec(b0).*t-tan(b).*fv-fu)/2; u=(fu*cos(al)-fv*sin(al))/m;
v=(fu*sin(al)+fv*cos(al))/m-g*t; x=(fx*cos(al)-fy*sin(al))/m^2;
y=(fx*sin(al)+fy*cos(al))/m^2-g*t.^2/2; th=b+al*un;
%
figure(1); clf; plot(x,y,x(N),y(N),'ro',0,0,'ro'); grid
axis([-.05 .23 0 .21]); xlabel('x/at_f^2'); ylabel('y/at_f^2') 
%
figure(2); clf; subplot(211); plot(t,th/c); grid; ylabel('\theta (deg)')
subplot(212), plot(t,u,t,v,'r--'); grid; xlabel('t/t_f') 
legend('u/at_f','v/at_f',2)
	
	