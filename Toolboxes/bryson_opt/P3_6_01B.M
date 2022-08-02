% Script p3_6_01b.m; VDP for max range with gravity and yf specified
% using FOPCB; s=[V y x]';                             8/97, 5/27/02
%
sf=[.7746 .3 .3]; nu=.3816; p0=[sf nu]; s0=[0 0 0]'; 
tf=1; name='vdpc'; global yf; yf=.3; 
optn=optimset('Display','Iter','MaxIter',15);
p=fsolve('fopcb',p0,optn,name,s0,tf);
[f,t,y1]=fopcb(p,name,s0,tf); y=y1(:,2); x=y1(:,3); N=length(t);
%
figure(1); clf; plot(x,-y,x,-y,'.',x(1),-y(1),'o',0,0,'o');
grid; axis([0 .35 -.35 0]); axis('square'); xlabel('x'); ylabel('y')

	

   