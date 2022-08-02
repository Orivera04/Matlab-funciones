% Script p3_5_11b.m; DVDP for max range with gravity, thrust, and spec.
% yf using DOPCB; t in tf, a in g, s=[v x y]'; v in g*tf, (x,y)
% in g*tf^2;                                              4/97, 5/27/02                 
%
N=20; sf=[.490 .332 .1]; nu=1.582; s0=[0 0 0]'; p0=[sf nu]; 
name='dvdpct'; optn=optimset('Display','Iter','MaxIter',20);
tf=1; uf=1.056; p=fsolve('dopcb',p0,optn,name,uf,s0,tf,N);  
[f,s,ga]=dopcb(p,name,uf,s0,tf,N);  N1=N+1; x=s(2,:); 
y=s(3,:); t=tf*[0:1/N:1]; gah=180*[ga ga(N)]/pi;
%
figure(1); clf; plot(x,y,x,y,'.',x(N1),y(N1),'ro',0,0,'ro'); grid
axis([0 .4 -.15 .15]); ylabel('y/gt_f^2'); xlabel('x/gt_f^2')
%
figure(2); clf; zohplot(t,gah); grid; xlabel('t/t_f')
ylabel('\gamma (deg)'); axis([0 1 -90 90])

	