% Script p3_6_10n.m; TDP for max uf with gravity and specified
% (vf,yf,xf) with FOPCN; s=[u v y x]';	              3/97, 5/28/02
%
clear; clear global; global vf yf xf g; vf=0; yf=.2; xf=.15; g=1/3;
th=[1.596 1.583 1.568 1.550 1.531 1.507 1.480 1.447 1.407 1.358 ...
   1.295 1.214 1.106 0.962 0.767 0.515 0.219 -.075 -.324 -.515 ...
   -.657 -.763 -.843 -.904-0.953 -.993 -1.025]; c=180/pi;
nu=[-1.6472 4.6224 -1.0744]; tf=1; s0=zeros(4,1);
p0=[th nu]; name='tdpgx'; 
optn=optimset('Display','Iter','MaxIter',500); 
p=fsolve('fopcn',p0,optn,name,s0,tf);
[f,s,la0]=fopcn(p,name,s0,tf);  N1=length(th); th=c*p([1:N1]); 
N=N1-1; u=s(1,:); v=s(2,:); y=s(3,:); x=s(4,:); t=[0:N]/N;
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid
axis([-.05 .23 0 .21]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), plot(t,th); grid; ylabel('\theta (deg)')
subplot(212), plot(t,u,t,v,'r--'); grid; xlabel('t/t_f')
legend('u/at_f','v/at_f',2)

	