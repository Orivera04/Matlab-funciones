% Script p2_6_6f.m; VDP for max range with gravity, thrust, and drag
% using FOP0F, a/g=1;                                  5/97, 6/30/02
%
tf=3; la0=[.6133 1 0]; s0=[0 0 0]'; name='vdptd0'; global a; a=.05;
optn=optimset('Display','Iter','MaxIter',100);
la0=fsolve('fop0f',la0,optn,name,s0,tf);
[f,t,s]=fop0f(la0,name,s0,tf); N=length(t); V=s(:,1); x=s(:,2);
y=s(:,3); ke=V.^2/2; 
%
figure(1); clf; subplot(211); plot(x,-y,x,-y,'b.',x(N),-y(N),...
  'ro',0,0,'ro'); grid; ylabel('-y'); xlabel('x'); subplot(212),
plot(ke,-y,ke,-y,'.',ke(N),-y(N),'ro',0,0,'ro'); grid
ylabel('-y'); xlabel('V^2/2')

% This problem has dissipation (drag) and single-shooting does NOT
% WORK for tf > about 3! See Pb. 2.6.6n.