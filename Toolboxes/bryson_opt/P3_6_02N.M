% Script p3_6_02n.m; VDP for max range with uc=Vy/h & spec. yf using
% FOPCN; s=[x y]' in units of h, t in units of h/V;    4/97, 5/28/02
%
clear; clear global; global yf; yf=0; N=20; s0=[0 0]'; tf=6; 
th0=pi/3*[1:-2/N:-1]; nu=-3; name='zrmc'; p0=[th0 nu]; c=180/pi;   
optn=optimset('Display','Iter','MaxIter',15);
p=fsolve('fopcn',p0,optn,name,s0,tf); t=tf*[0:N]/N;
[f,s,la0]=fopcn(p,name,s0,tf); x=s(1,:); y=s(2,:); th=p([1:N+1]);
%
% Location of tips of thrust vectors:
for i=1:N+1
     xt(i)=x(i)+1.5*cos(th(i)); yt(i)=y(i)+1.5*sin(th(i)); end
%
figure(1); clf; plot(x,y); grid; hold on; for i=1:N+1 
  pltarrow([x(i) xt(i)],[y(i) yt(i)],.22,'r','-'); end
hold off; axis([0 12 -2 7]); xlabel('x/h'); ylabel('y/h')
%
figure(2); clf; plot(t,th*c); grid; xlabel('t')
ylabel('\theta (deg)')
       

       
       