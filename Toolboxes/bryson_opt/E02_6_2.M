% Script e02_6_2.m; min drag nose shape using FOP0F; 
%                                          10/96, 6/25/02
%
tf=4; s0=[0 1]'; name='noshp'; la0=[1 .3785]; p0=la0; 
optn=optimset('Display','Iter','MaxIter',500);
p=fsolve('fop0f',p0,optn,name,s0,tf);
[f,t,y]=fop0f(p,name,s0,tf); d=y(:,1); r=y(:,2);
N=length(t); 
%
figure(1); clf; plot(t,r,t,-r,[3.995 3.995],[r(N) -r(N)])
grid; axis([0 4 -1.5 1.5]); xlabel('x/a'); ylabel('r/a')
	
	