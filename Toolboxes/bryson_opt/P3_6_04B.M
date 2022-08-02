% Script p3_6_04b.m; max range in given time with V=1+y and specified
% yf using FOPCB;                                       4/97, 5/28/02
%
clear; clear global; global yf; yf=0; sf=[2.3505 0]; nu=-1.1751;
s0=[0 0]'; tf=2; name='frmc'; p0=[sf nu]; 
optn=optimset('Display','Iter','MaxIter',15);
p=fsolve('fopcb',p0,optn,name,s0,tf);
[f,t,y]=fopcb(p,name,s0,tf); 	x=y(:,1); y1=y(:,2); N=length(t);
%
figure(1); clf; plot(x,y1,x(1),y1(1),'ro',0,0,'ro'); grid; 
xlabel('x'); ylabel('y'); axis([0 2.5 -.6 1.28])
	 
	   
	
	
