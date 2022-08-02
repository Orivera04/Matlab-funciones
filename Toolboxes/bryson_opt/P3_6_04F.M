% Script p3_6_04f.m; max range in given time with V=1+y and yf speci-
% fied (Fermat Pb.) using FOPCF;                        3/97, 5/28/02
%
clear; clear global; global yf; yf=0; la0=[1 1.1751]; nu=-1.1751;
s0=[0 0]'; tf=2; name='frmc'; p0=[la0 nu];
optn=optimset('Display','Iter','MaxIter',15);
p=fsolve('fopcf',p0,optn,name,s0,tf);
[f,t,y]=fopcf(p,name,s0,tf); x=y(:,1); y1=y(:,2); N=length(t);
%
figure(1); clf; plot(x,y1,x(N),y1(N),'ro',0,0,'ro'); grid; 
xlabel('x'); ylabel('y'); axis([0 2.5 -.6 1.28])

	
	 
	   
	
	
