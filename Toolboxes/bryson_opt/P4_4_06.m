% Script p4_4_06.m; TDP for min tf with vf=0 and uf,yf spec.; finds
% p=th0 in analytic solution to satisfy terminal BCs using FSOLVE;
% (u,v) in uf, (x,y) in uf^2/a, t in uf/a;              2/97, 3/29/02
%
yf=.2/.6753^2; c=pi/180; p0=c*67;
optn=optimset('Display','Iter','MaxIter',100);  
p=fsolve('tdpt_f',p0,optn,yf); [f,m,tf]=tdpt_f(p,yf);
%
th0=p; t=tf*[0:.01:1]; N=101; un=ones(1,N); th=atan(un*tan(th0)-m*t);
u=(1/m)*(asinh(tan(th0))-asinh(tan(th))); v=(1/m)*(sec(th0)-sec(th)); 
y=(.5/m)*(sec(th0)*t-tan(th).*v-u); x=(1/m)*(v-tan(th).*u);
%
figure(1); clf; plot(x,y,x(N),y(N),'ro',0,0,'ro'); grid;
xlabel('ax/u_f^2'); ylabel('ay/u_f^2'); axis([0 .8 0 .6]);
%
figure(2); clf; subplot(211),	plot(t,th/c); grid; 
ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); grid;
xlabel('at/u_f'); legend('u/u_f','v/u_f',2); axis([0 1.5 0 1]);





	