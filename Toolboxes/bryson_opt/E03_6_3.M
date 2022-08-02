% Script e03_6_3.m; max radius orbit transfer using FOPCB; guess of sf
% and nu from FOPC;	                                     3/97, 6/25/02
%
sf=[1.5237 0 .8101 0]; nu=[-1.426 1.276]; p0=[sf nu]; s0=[1 0 1 0]'; 
tf=3.3155; name='marc'; optn=optimset('Display','Iter','MaxIter',50); 
p=fsolve('fopcb',p0,optn,name,s0,tf); [f,t,y]=fopcb(p,name,s0,tf);
r=y(:,1); v=y(:,2); u=y(:,3); th=y(:,4); lr=y(:,5); lv=y(:,6);
lu=y(:,7); be=atan2(lv,lu); N=length(t); c=180/pi;
for i=1:N, if be(i)<0; be(i)=be(i)+2*pi; end; end
%
figure(1); clf; plot(t,r,t,v,'r--',t,u,'k-.'); grid; xlabel('Time') 
legend('r','v','u',2)
%
figure(2); clf; plot(t,lr,t,lv,'r--',t,u,'k-.');
legend('\lambda_r','\lambda_v','\lambda_u',3); xlabel('Time'); grid
%
figure(3); clf; plot(t,be*c); grid; xlabel('Time')
ylabel('\beta (deg)')
