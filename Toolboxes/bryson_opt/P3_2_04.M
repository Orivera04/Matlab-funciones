% Script p3_2_04.m; DVDP for max range with V=1+y and
% yf  specified (Fermat Pb.) using DOPC; 11/96, 3/30/02
%
s0=[0 0]'; global yf; yf=.25; th0=[.8:-.16:-.8]; tf=2; 
N=length(th0); k=-1; tol=.0001; mxit=10; 
[u,s,la0,nu]=dopc('dfrmc',th0,s0,tf,k,tol,mxit); 
x=s(1,:); y=s(2,:); 
%	
figure(1); clf; plot(x,y,x,y,'ro'); grid; xlabel('x')
ylabel('y'); axis([0 3 -.25*3 .5*3])
