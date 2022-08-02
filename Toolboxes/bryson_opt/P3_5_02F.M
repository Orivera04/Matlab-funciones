% Script p3_5_02f.m; DVDP for max range with uc=Vy/h, & spec. yf using 
% DOPCF; s=[x y]' in units of h, t in units of h/V;      5/97, 6/22/98
%
N=50; s0=[0 0]'; tf=6; la0=[1 3]; name='dzrmc'; u0=1.2; nu=-3;
p0=[la0 nu]; optn=optimset('Display','Iter','MaxIter',500);
p=fsolve('dopcf',p0,optn,name,u0,s0,tf,N);
[f,s,th,la]=dopcf(p,name,u0,s0,tf,N); t=[0:N]/N; thh=[th th(N)];
x=s(1,:); y=s(2,:);
%
% Location of tips of thrust vectors:
for i=1:N, xt(i)=x(i)+2*cos(th(i)); yt(i)=y(i)+2*sin(th(i)); end
%
figure(1); clf; plot(x,y,'b.',x,y); grid; hold on 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.3,'b','-'); end
hold off; axis([0 12 -4 5]); xlabel('x/h'); ylabel('y/h')
       

       
       