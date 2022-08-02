% Script p3_2_09a.m; DTDP w. const a and gv; max uf w. spec.(vf,yf,tf);
% t in tf, (u,v) in a*tf, (x,y) in a*tf^2, gv in a; s=[u v y x]';
% be=ctrl; x is an ignorable coord., included for trajectory plot; 
% soln. using FMINCON;                             11/94, 6/98, 3/13/02  
%
N=10; s0=zeros(4,1); tf=1; gv=1/3; yf=.2; un=ones(1,N);
th=(80*pi/180)*[1:-2/N:-1+2/N]; ub=2*un; lb=-ub; t=[0:1/N:1]; 
optn=optimset('Display','Iter','MaxIter',60);
th=fmincon('dtdp_fz',th,[],[],[],[],lb,ub,'dtdp_cz',optn,s0,tf,N,gv,yf);
thh=[th th(N)]*180/pi; [f,u,v,y,x]=dtdp_f(th,s0,tf,N,gv,yf);
%
% Spline fit to double number of points in (x,y):
ti=[0:.5/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
ui=spline(t,u,ti); vi=spline(t,v,ti);
%
% Coord. of tips of thrust direction arrows:
for i=1:N, xt(i)=x(i)+.06*cos(th(i)); yt(i)=y(i)+.06*sin(th(i)); end
%
figure(1); clf; plot(x,y,'.b',xi,yi,'b'); grid; hold on; 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.008,'r','-'); end;
hold off; axis([-.04 .24 0 .21]); 
xlabel('x/(a*t_f^2)'); ylabel('y/(a*t_f^2)');
%
figure(2); clf; subplot(211), zohplot(t,thh); grid; 
ylabel('\theta (deg)'); subplot(212), plot(ti,ui,ti,vi,'r--'); grid;
xlabel('t/t_f'); legend('u/a*t_f','v/a*t_f',2);




