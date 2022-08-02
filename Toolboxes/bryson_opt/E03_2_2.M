% Script e03_2_2.m; DTDP for max uf to vf=0, spec. yf using FMINCON; 
% t in units of tf, (u,v) in a*tf; (x,y) in a*tf^2; s=[u v y x]';
% th=control; ignorable coord. x is included for plotting;
%                                               11/94, 6/98, 3/13/02  
%
N=10; s0=zeros(4,1); tf=1; un=ones(1,N); yf=.2; gv=0; t=[0:N]/N; 
th=(pi/3)*[1:-2/N:-1+2/N]; ub=(pi/2)*un; lb=-ub;  
optn=optimset('Display','Iter','MaxIter',500); 
th=fmincon('dtdp_f',th,[],[],[],[],lb,ub,'dtdp_c',optn,s0,tf,N,gv,yf);
[f,u,v,y,x]=dtdp_f(th,s0,tf,N,gv,yf); uh=[th th(N)];
%
% Spline fit (x,y):
ti=[0:.5/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
%
% Coordinates of tips of thrust direction arrows:
for i=1:N, xt(i)=x(i)+.06*cos(th(i)); yt(i)=y(i)+.06*sin(th(i)); end
%
figure(1); clf; plot(x,y,'b.'); grid; hold on; plot(xi,yi,'b');
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.012,'r','-');
end; hold off; axis([0 .35 0 .22]); xlabel('x/(a*t_f^2)');
ylabel('y/(a*t_f^2)');
%
figure(2); clf; subplot(211), zohplot(t,uh*180/pi); grid;
ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); grid;
xlabel('t/t_f'); legend('u/(a*t_f)','v/(a*t_f)',2);



