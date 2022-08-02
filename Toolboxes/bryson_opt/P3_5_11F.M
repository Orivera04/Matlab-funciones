% Script p3_5_11f.m; DVDP for max range with gravity, thrust, and spec.
% yf using DOPCF; t in tf, a in g, s=[v x y]'; v in g*tf, (x,y) in
% g*tf^2;                                                 4/97, 5/27/02                 
%
N=20; la0=[.694 1 1.876]; s0=[0 0 0]'; name='dvdpct';
nu=1.582; p0=[la0 nu]; tf=1; u0=-1.42; c=180/pi;
optn=optimset('Display','Iter','MaxIter',500);
p=fsolve('dopcf',p0,optn,name,u0,s0,tf,N);  
[f,s,ga]=dopcf(p,name,u0,s0,tf,N); N1=N+1; x=s(2,:); 
y=s(3,:); t=tf*[0:1/N:1]; gah=c*[ga ga(N)];
%
figure(1); clf; plot(x,y,x,y,'.',x(N1),y(N1),'ro',0,0,'ro'); grid
axis([0 .4 -.15 .15]); ylabel('y/gt_f^2'); xlabel('x/gt_f^2')
%
figure(2); clf; zohplot(t,gah); grid; xlabel('t/t_f')
ylabel('\gamma (deg)'); axis([0 1 -90 90])



	