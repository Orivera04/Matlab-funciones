% Script p4_4_07.m; TDP for min tf rendezvous; finds p=(thb0,thbf) in
% analytic solution to give vf=0 & spec. (uf,yf,xf) using FSOLVE; (u,v)
% in uf, (x,y) in uf^2/a, t in uf/a;                      2/97, 3/29/02
%
xf=.15/.4875^2; yf=.2/.4875^2; c=pi/180; p0=c*[77.2557 -82.6776];
optn=optimset('Display','Iter','MaxIter',100); 
p=fsolve('tdpxt_f',p0,optn,yf,xf); [f,tf,m,al]=tdpxt_f(p,yf,xf);
%
b0=p(1); t=tf*[0:.01:1]; N=101; un=ones(1,N); b=atan(un*tan(b0)-m*t);  
fu=asinh(tan(b0))-asinh(tan(b)); fv=sec(b0)-sec(b); fx=fv-tan(b).*fu;
fy=(m*sec(b0).*t-tan(b).*fv-fu)/2; u=(fu*cos(al)-fv*sin(al))/m; 
v=(fu*sin(al)+fv*cos(al))/m; x=(fx*cos(al)-fy*sin(al))/m^2; 
y=(fx*sin(al)+fy*cos(al))/m^2; th=b+al*un;   
%
figure(1); clf; plot(x,y,x(N),y(N),'ro',0,0,'ro'); grid
axis([-.3 .9 0 .9]); xlabel('ax/uf^2'); ylabel('ay/uf^2')
%
figure(2); clf; subplot(211), plot(t,th/c); grid
ylabel('\theta (deg)'); axis([0 2.2 -60 120]); subplot(212),
plot(t,u,t,v,'r--'); grid; xlabel('at/uf'); legend('u/uf','v/uf',2);
axis([0 2.2 -.2 1]) 
	
	