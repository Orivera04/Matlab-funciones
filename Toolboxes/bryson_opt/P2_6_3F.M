% Script p2_6_3f.m; VDP for min distance to a meridian on a sphere
% using FOP0F;                                       3/97, 6/30/02
%
c=pi/180; tf=50*c; s0=[0 40*c]'; la0=[1 -0.6081]; p0=la0;
name='geo0'; optn=optimset('Display','Iter','MaxIter',100);
p=fsolve('fop0f',p0,optn,name,s0,tf);
[f,t,y]=fop0f(p,name,s0,tf); ph=t/c; d=y(:,1); th=y(:,2)/c;
N=length(t); 
%
figure(1); clf; plot(ph,th,ph,th,'b.',ph(1),th(1),'ro',...
    ph(N),th(N),'ro'); grid; xlabel('\phi (deg)')
ylabel('\theta (deg)')

	