% Script p3_6_04n.m; VDP for max range with V=1+y & specified yf;
% (Fermat Pb.) using FOPCN;                        11/96, 5/28/02
%
global yf; yf=0; name='frmc'; s0=[0 0]'; th0=[.8:-.05:-.8]; tf=2;
nu=-1.1751; p0=[th0 nu]; N=length(th0)-1; t=tf*[0:1/N:1]; 
told=1e-5; tols=5e-4; 
optn=optimset('Display','Iter','MaxIter',15);
p=fsolve('fopcn',p0,optn,name,s0,tf); N1=N+1;
[f,s,u,la0]=fopcn(p,name,s0,tf); x=s(1,:); y=s(2,:);  
%	
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid
xlabel('x'); ylabel('y'); axis([0 2.5 -.6 1.28])
