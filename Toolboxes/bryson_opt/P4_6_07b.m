% Script p4_6_07b.m; DTDP for min tf to vf=0 and spec. (uf,yf,xf)
% using DOPTB; (u,v) in uf, (x,y) in uf^2/a, t in uf/a;
%                                                 3/97, 3/28/02
%
N=10; sf=[1 0 .8419 .6314]'; s0=[0 0 0 0]'; tf=2.0561;
name='dtdptx'; nu=[-1.1497 1.3100 -1.0914 .7374]';
p0=[sf' nu' tf]; optn=optimset('Display','Iter','MaxIter',50);
uf=-1; p=fsolve('doptb',p0,optn,name,uf,s0,N);
[f,s,th,la]=doptb(p,name,uf,s0,N); thh=[th th(N)]*180/pi;
t=[0:1/N:1]; u=s(1,:); v=s(2,:); y=s(3,:); x=s(4,:);  
%
% Spline fit to double number of points in (x,y):
ti=tf*[0:.5/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
%
% Coord. of tips of thrust direction arrows:
for i=1:10, xt(i)=x(i)+.16*cos(th(i)); yt(i)=y(i)+.16*sin(th(i));
end
% 
figure(1); clf; plot(x,y,x,y,'b.'); grid; hold on 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.02,'r','-'); end
hold off; axis([-.3 .9 0 .9]); xlabel('ax/u_f^2');  ylabel('ay/u_f^2')
%
figure(2); clf; subplot(211), zohplot(t,thh); grid
ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); grid
xlabel('t/t_f'); legend('u/u_f','v/u_f',2)
 	