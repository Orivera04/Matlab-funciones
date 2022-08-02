% Script p3_5_02n.m; DVDP for max range with uc=Vy/h, & spec. yf using
% DOPCN; s=[x y]' in units of h, t in units of h/V;      5/97, 5/27/02
%
N=50; s0=[0 0]'; tf=6; th0=pi/3*[1:-2/N:-1+2/N]; name='dzrmc';
nu=-.4871; p0=[th0 nu]; optn=optimset('Display','Iter','MaxIter',500);
p=fsolve('dopcn',p0,optn,name,s0,tf);
[f,s,la0]=dopcn(p,name,s0,tf); t=[0:N]/N; th=p([1:N]); thh=[th th(N)];
x=s(1,:); y=s(2,:);
%
% Location of tips of thrust vectors:
for i=1:N, xt(i)=x(i)+2*cos(th(i)); yt(i)=y(i)+2*sin(th(i)); end
%
figure(1); clf; plot(x,y,'b.',x,y); grid; hold on; 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.3,'b','-'); end;
hold off; axis([0 12 -4 5]); xlabel('x/h'); ylabel('y/h')
       
	