% Script p3_5_04b.m; DVDP for max range with V=1+y & yf spec.
% (Fermat Pb.) using DOPCB;                     5/97, 5/27/02
%
s0=[0 0]'; tf=2; global yf; yf=.25; N=11; name='dfrmc'; 
nu=-.9590; uf=-.6962; sf=[2.6123 .2500]; p0=[sf nu]; 
optn=optimset('Display','Iter','MaxIter',500); 
p=fsolve('dopcb',p0,optn,name,uf,s0,tf,N);
[f,s,u]=dopcb(p,name,uf,s0,tf,N); N1=N+1;
uh=[u u(N)]; x=s(1,:); y=s(2,:); t=tf*[0:1/N:1]; 
%	
figure(1); clf; plot(x,y,x,y,'.',0,0,'ro',x(N1),y(N1),'ro');
grid; xlabel('x'); ylabel('y'); axis([0 2.8 -.6 1.5])
%
figure(2); clf; zohplot(t,uh); grid; xlabel('Time') 
ylabel('u')