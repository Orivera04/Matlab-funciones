% Script p4_3_06a.m; DTDP for min tf to vf=0 and specified (uf,yf);
%(u,v) in uf, (x,y) in uf^2/a, t in uf/a, using FMINCON;  2/97, 3/29/02
%
yf=.2/.6716^2; th=[1:-2/9:-1]; tf=1/.6716; p=[th tf]; 
optn=optimset('Display','Iter','MaxIter',34);
p=fmincon('dtdpt_f1',p,[],[],[],[],[],[],'dtdpt_c1',optn,yf);
[c,ceq,u,v,x,y]=dtdpt_c1(p,yf); N=10; tf=p(N+1); t=tf*[0:1/N:1];
th=p([1:N]); thh=[th th(N)];
%
% Spline fit to double number of points in (x,y):
ti=tf*[0:.5/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
%
% Coord. tips of thrust direction arrows:
for i=1:N, xt(i)=x(i)+.12*cos(th(i)); yt(i)=y(i)+.12*sin(th(i)); end
%
figure(1); clf; plot(x,y,'b.',xi,yi,'b'); grid; hold on; 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.02,'r','-'); end;
hold off; axis([0 .8 0 .6]); xlabel('ax/u_f^2'); ylabel('ay/u_f^2');
%
figure(2); clf; subplot(211), zohplot(t,thh*180/pi); grid; 
ylabel('\theta (deg)'); axis([0 1.5 -100 100]);
subplot(212), plot(t,u,t,v,'r--'); grid; xlabel('at/u_f');
axis([0 1.5 0 1]); legend('u/u_f','v/u_f',2); 
 