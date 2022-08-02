% Script p3_5_02b.m; DVDP for max range with uc=Vy/h, & spec. yf using
% DOPCB; s=[x y]' in units of h, t in units of h/V;      5/97, 5/27/02
%
N=50; s0=[0 0]'; tf=6; sf=[11.2982 0]; name='dzrmc'; nu=-3; p0=[sf nu];
uf=-1.2; optn=optimset('Display','Iter','MaxIter',500); 
p=fsolve('dopcb',p0,optn,name,uf,s0,tf,N);
[f,s,th,la]=dopcb(p,name,uf,s0,tf,N); t=[0:N]/N; thh=[th th(N)]; 
x=s(1,:); y=s(2,:);
%
% Calculate location of tips of thrust vectors:
for i=1:N, xt(i)=x(i)+2*cos(th(i)); yt(i)=y(i)+2*sin(th(i)); end
%
figure(1); clf; plot(x,y,'b.',x,y); grid; hold on; 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.3,'b','-'); end;
hold off; axis([0 12 -4 5]); xlabel('x/h'); ylabel('y/h')
       

       
       