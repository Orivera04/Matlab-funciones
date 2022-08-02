% Script p2_3_2.m; VDP for max range w. V=Vo*y/h; plots from
% explicit analytical solution.                10/96, 6/24/02
%
tf=2; N=60; th0=atan(tf); th=th0*[1:-1/N:0]; figure(1); clf 
y0a=[0 .1 -.1]; for i=1:3, y0=y0a(i); ta=tan(th);
ta0=tan(th0); un=ones(1,N+1); se=un./cos(th); se0=1/cos(th0);
t=un*ta0-ta; y=un*(se0+y0)-se;
x=t*(y0+se0)+(log((se0+ta0)*un./(se+ta))+ta.*se-un*ta0*se0)/2;
%
figure(1); plot(x,y,x(N+1),y(N+1),'ro',0,y0,'ro'); 
axis([0 3.2 -.2 2.2]); xlabel('x/h'); ylabel('y/h'); hold on
end; hold off; grid
title('VDP for Max Range with V=Vo*y/h (Zermelo Pb.)')
	 


	
	