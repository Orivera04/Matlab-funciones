% Script p2_6_5n.m; VDP for max range w. gravity & thrust using FOP0N;
%                                                         2/97, 7/15/02
%
s0=[0 0 0]'; tf=1; name='vdpt0'; N=40; ga0=[1.571 1.531 1.492 1.453 ...
   1.414 1.374 1.335 1.296 1.257 1.217 1.178 1.139 1.100 1.060 1.021 ...
   .982 .942 .903 .864 .825 .785 .746 .707 .667 .628 .589 .550 ...
   .510 .471 .432 .393 .353 .314 .275 .236 .196 .157 .118 .078 .039 0];
optn=optimset('Display','Iter','MaxIter',500); t=[0:1/N:1]; 
ga=fsolve('fop0n',ga0,optn,name,s0,tf);
[f,s,la0]=fop0n(ga,name,s0,tf); x=s(2,:); y=s(3,:);
%
figure(1); clf; subplot(211), plot(x,-y,x(N+1),-y(N+1),'ro'); grid; 
axis([0 .8 -.3 0]); xlabel('x'); ylabel('y');
subplot(212), plot(t,x,t,-y); grid; xlabel('Time') 
legend('x','y',2);
	