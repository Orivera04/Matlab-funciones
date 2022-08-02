% Script e04_6_1.m; DTDP for min tf to vf=0 & spec. (uf,yf) using DOPTN;
% (u,v) in uf, (x,y) in uf^2/a, t in uf/a;  		  		 1/98, 6/25/02
%
% th=[1:-2/9:-1];	                                  % Rough intial guess 
th=[1.133 1.029 .871 .619 .233 -.233 -.619 -.871 -1.029 -1.133];
N=length(th); s0=[0 0 0 0]'; tf=1.4834; nu=[-.0389 .0924 -.1246]';
p0=[th nu' tf]; name='dtdpt'; optn=optimset('Display','Off','MaxIter',500);
p=fsolve('doptn',p0,optn,name,s0);
[f,s]=doptn(p,name,s0); t=tf*[0:.1:1]; u=s(1,:); v=s(2,:); y=s(3,:);
x=s(4,:); thh=[th th(10)]; 
%
% Spline fit to double number of points in (x,y):
ti=tf*[0:.5/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
%
% Coord. tips of thrust direction arrows:
for i=1:N, xt(i)=x(i)+.12*cos(th(i)); yt(i)=y(i)+.12*sin(th(i)); end
%
figure(1); clf; plot(x,y,'b.',xi,yi,'b'); grid; hold on 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.02,'r','-'); end
hold off; axis([0 .8 0 .6]); xlabel('ax/u_f^2'); ylabel('ay/u_f^2')
%
figure(2); clf; subplot(211), zohplot(t,thh*180/pi); grid 
ylabel('\theta (deg)'); axis([0 1.5 -100 100])
subplot(212), plot(t,u,t,v,'r--'); grid; xlabel('at/u_f');
axis([0 1.5 0 1]); legend('u/u_f','v/u_f',2) 
