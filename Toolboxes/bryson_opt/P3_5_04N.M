% Script p3_5_04n.m; DVDP for max range with V=1+y & yf spec. using 
% DOPCN (Fermat Pb.)                                  5/97, 5/27/02
%
s0=[0 0]'; th0=[.8:-.16:-.8]; tf=2; global yf; yf=.25; 
N=length(th0); k=-1; tol=1e-4; mxit=10; name='dfrmc'; 
[u,s,nu]=dopc(name,th0,s0,tf,k,tol,mxit);
optn=optimset('Display','Iter','MaxIter',500); N1=N+1; p0=[u nu];
p=fsolve('dopcn',p0,optn,name,s0,tf);
[f,s,la0]=dopcn(p,name,s0,tf); u=p([1:N]); uh=[u u(N)]; x=s(1,:);
y=s(2,:); t=tf*[0:1/N:1]; 
%	
figure(1); clf; plot(x,y,x,y,'.',0,0,'ro',x(N1),y(N1),'ro');
grid; xlabel('x'); ylabel('y'); axis([0 2.8 -.6 1.5])
%
figure(2); clf; zohplot(t,uh); grid; xlabel('Time'); ylabel('u');