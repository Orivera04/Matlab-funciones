% Script p3_6_01f.m; VDP for max range with gravity and yf specified
% using FOPCF;		                                   4/97, 7/27/02
%
la0=[.8290 .3816 1]; nu=.3816; p0=[la0 nu]; s0=[0 0 0]'; tf=1;
name='vdpc'; optn=optimset('Display','Iter','MaxIter',15);
global yf; yf=.3; p=fsolve('fopcf',p0,optn,name,s0,tf);
[f,t,y1]=fopcf(p,name,s0,tf); y=y1(:,2); x=y1(:,3); N=length(t);
%
figure(1); clf; plot(x,-y,x,-y,'.',x(N),-y(N),'o',0,0,'o');
grid; axis([0 .35 -.35 0]); axis('square'); xlabel('x'); ylabel('y')

	
   