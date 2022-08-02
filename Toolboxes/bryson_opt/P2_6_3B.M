% Script p2_6_3b.m; VDP for min distance to a meridian on a sphere
% using FOP0B;                                       4/97, 6/30/02
%
c=pi/180; tf=50*c; s0=[0 40*c]'; sf=[.6271 .9171]'; p0=sf;
name='geo0'; optn=optimset('Display','Iter','MaxIter',100);
p=fsolve('fop0b',p0,optn,name,s0,tf);
[f,t,y]=fop0b(p,name,s0,tf); N=length(t); ph=t/c; d=y(:,1);
th=y(:,2)/c;  
%
figure(1); clf; plot(ph,th,ph,th,'b.',ph(1),th(1),'ro',...
    ph(N),th(N),'ro'); 
grid; xlabel('\phi (deg)'); ylabel('\theta (deg)')

	