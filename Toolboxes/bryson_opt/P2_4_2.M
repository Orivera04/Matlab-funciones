% Script p2_4_2.m; max range in given time with uc=y/h (Zermelo Pb.)
% using FOP0;                                          2/97, 6/24/02
%
name='zrm0'; N=20; tf=2; tu=tf*[0:1/N:1]'; u0=.5*ones(N+1,1);
y0a=[0 .1 -.1]; k=-.3; told=1e-5; tols=1e-5; mxit=50; figure(1); clf; 
for i=1:3, y0=y0a(i); s0=[0 y0]'; 
 [t,u,s]=fop0(name,tu,u0,tf,s0,k,told,tols,mxit);
 x=s(:,1); y=s(:,2); N=length(x);
 % 
 plot(x,y,x(N),y(N),'ro',0,y0,'ro'); 
 axis([0 3.2 -.2 2.2]); hold on 
end; hold off; grid; xlabel('x/h'); ylabel('y/h')
	

	
	