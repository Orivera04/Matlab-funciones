% Script p2_6_1n.m; VDP for max range with gravity; dual of brach-
% istochrone Pb. w. FOP0N;                           2/97, 6/30/02
%
s0=[0 0 0]'; tf=1; N1=21;
u=[1.571 1.492 1.414 1.335 1.257 1.178 1.010 1.021 .942 .864...
   0.785 0.707 0.628 0.550 0.471 0.393 0.314 0.236 .157 .079 0];
% u=.4*ones(1,N1);                          % Rough initial guess
p0=u; name='vdp0'; optn=optimset('Display','Iter','MaxIter',100);
p=fsolve('fop0n',p0,optn,name,s0,tf);
[f,s,la0]=fop0n(p,name,s0,tf); t=tf*[0:.05:1]'; V=s(1,:);
x=s(2,:); y=s(3,:);
%
figure(1); clf; plot(x,-y,x(N1),-y(N1),'ro'); grid;
axis([0 .36 -.27 0]); xlabel('x'); ylabel('y');

	