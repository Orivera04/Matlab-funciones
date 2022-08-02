% Script p4_4_02.m; VDP for min time to a point with uc=Vy/h, s=[x y]'
% in units of h, t in units of h/V;                     12/96, 6/10/02
%
clear; clear global; global xf yf; N=20; yf=0; xf=11.3; p=[2 4]; 
N1=N+1; optn=optimset('Display','Iter'); 
p=fsolve('zrmt_f',p,optn); th0=atan(p(1)); tf=p(2); 
t=tf*[0:1/N:1]; un=ones(1,N1); th=atan(p(1)*un-t);
y=un/cos(th0)-un./cos(th); x=.5*(un*asinh(p(1))-asinh(tan(th))+...
  tan(th)./cos(th)-un*tan(th0)/cos(th0))+t/cos(th0); 
%
% Coord. of tips of thrust vectors:
for i=1:N1, a=th(i);
     xt(i)=x(i)+1.5*cos(a); yt(i)=y(i)+1.5*sin(a); end 
%
figure(1); clf; plot(x,y,0,0,'ro',x(N1),y(N1),'ro');
grid; hold on 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.3,'r','-'); end
hold off; axis([0 12 -3 6]); xlabel('x/h'); ylabel('y/h') 
       

       
       