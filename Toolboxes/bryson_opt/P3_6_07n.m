% Script p3_6_07n.m; TDP for max uf with spec. (vf,yf,xf); s=[u v y x]';
%                                                          2/97, 5/28/02
%
clear; clear global; global vf yf xf; vf=0; yf=.2; xf=.15; name='tdpcx';
nu=[-1.1755 2.0237 -1.2139]; th0=[1.6:-.1:-1.1]; N=length(th0)-1;
tf=1; t=tf*[0:1/N:1]; p0=[th0 nu]; N=length(th0)-1; s0=zeros(4,1);
t=tf*[0:1/N:1]; told=1e-5; tols=5e-4; 
optn=optimset('Display','Iter','MaxIter',15); 
p=fsolve('fopcn',p0,optn,name,s0,tf); N1=N+1; c=180/pi;
[f,s,th,la0]=fopcn(p,name,s0,tf); u=s(1,:); v=s(2,:); y=s(3,:); x=s(4,:);  
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid 
axis([-.02 .2 0 .22]); axis('square'); xlabel('x/at_f^2')
ylabel('y/at_f^2');
%
figure(2); clf; subplot(211), plot(t,th/c); grid
ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); grid
xlabel('t/t_f'); legend('u/at_f','v/at_f',2)

