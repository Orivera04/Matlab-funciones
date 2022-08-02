% Script p3_3_02.m; VDP for max range w. V=Vo*y/h with yf specified; 
% plots from analytical soln; p=[th0,thf];            12/96, 3/26/02
%
tf=1; yf=0; c=pi/180; p=[pi/6 -pi/6]; optn=optimset; 
p=fsolve('zermc_f',p,optn,tf,yf); th0=p(1); thf=p(2);
dth=(th0-thf)/100; th=[th0:-dth:thf]; un=ones(1,length(th));
se=un./cos(th); se0=1/cos(th0); ta=tan(th); ta0=tan(th0);
t=un*ta0-ta; y=un*se0-se;
x=(un*asinh(ta0)-asinh(ta)+ta.*se-un*ta0*se0)/2+se0*t;
%
figure(1); clf; plot(x,y,x(101),y(101),'ro',0,0,'ro'); grid;
axis([0 1.2 -.4 .5]); ylabel('y/h'); xlabel('x/h');
title('VDP for Max Range; uc=V*y/h & yf Specified');
	

	
	