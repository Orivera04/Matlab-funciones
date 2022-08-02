% Script p2_6_6b.m; VDP for max range with gravity, thrust, and drag
% using FOP0B, a/g=1;                                5/97, 6/30/02
%
tf=3; sf=[1.0880 2.7152 .9741]'; s0=[0 0 0]'; name='vdptd0';
optn=optimset('Display','Iter','MaxIter',100);
sf=fsolve('fop0b',sf,optn,name,s0,tf);
[f,t,y1]=fop0b(sf,name,s0,tf); V=y1(:,1); x=y1(:,2); y=y1(:,3);
N=length(t); ke=V.*V/2; 
%
figure(1); clf; subplot(211); plot(x,-y,x,-y,'b.',x(N),-y(N),'ro',...
   0,0,'ro'); grid; ylabel('-y'); xlabel('x'); subplot(212),
plot(ke,-y,ke,-y,'.',ke(N),-y(N),'ro',0,0,'ro'); grid; ylabel('-y');
xlabel('V^2/2');

% This problem has dissipation (drag) and single-shooting does NOT WORK
% for tf > about 3! See Pb. 2.6.6n.

	