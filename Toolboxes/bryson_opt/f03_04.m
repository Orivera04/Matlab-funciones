% Script f03_04.m; DTDP for max uf w. gravity to vf=0 
% and yf specified; finds nuv and nuy in linear tangent
% law to satisfy terminal BCs using FSOLVE; s=[u v y x]';  
%                                           2/97, 3/30/02
%
N=10; g=1/3; yf=.2; p=[-1 2]; 
optn=optimset('Display','Iter','MaxIter',200); 
p=fsolve('dtdpcgf',p,optn,N,g,yf); 
[f,u,v,y,x,th]=dtdpcgf(p,N,g,yf); t=[0:1/N:1]; 
thh=[th th(N)]; 
%
% Spline fit to increase number of points in (x,y):
ti=[0:.1/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
ui=spline(t,u,ti); vi=spline(t,v,ti); N1=N+1;
%
% Coordinates of tips of thrust direction arrows:
for i=1:N,
 xt(i)=x(i)+.06*cos(th(i)); yt(i)=y(i)+.06*sin(th(i));
end
%
figure(1); clf; plot(x,y,'b.',xi,yi,'b',x(N1),...
    y(N1),'ro'); grid; hold on; 
for i=1:N, 
   pltarrow([x(i) xt(i)],[y(i) yt(i)],.01,'r','-'); end
hold off; axis([0 .28 0 .21]); xlabel('x/a*tf^2') 
ylabel('y/a*tf^2')
%
figure(2); clf; subplot(211), zohplot(t,thh*180/pi);
grid; ylabel('\theta (deg)'); subplot(212),
plot(ti,ui,ti,vi,'r--'); grid; xlabel('t/t_f')
legend('u/at_f','v/at_f',2)

	
	


