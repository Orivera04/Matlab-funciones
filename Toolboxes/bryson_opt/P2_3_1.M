% Script p2_3_1.m; VDP for max range with gravity; plots from
% analytical soln.;                            10/96, 6/27/02
%
N=40; ga=(pi/2)*[1:-1/N:0]; alo=pi/4; al=ga/2; un=ones(1,N+1);
x=(4/pi^2)*((alo*un-al)-(1/4)*sin(2*ga)); N1=N+1; 
y=(2/pi^2)*(cos(ga)).^2; t=(4/pi)*(alo*un-al);
%
figure(1); clf; plot(x,-y,x(N1),-y(N1),'bo',0,0,'bo'); grid
axis([0 .4 -.3 0]); xlabel('x'); ylabel('y')
	