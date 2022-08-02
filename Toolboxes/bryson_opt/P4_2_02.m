% Script p4_2_02.m; DVDP for min time to a point w. uc=Vy/h  using FSOLVE;
%                                                           12/96, 7/25/02
%
N=20; nu=[-.01 .05]; dt=6/N; p=[nu dt]; 
optn=optimset('Display','Iter','MaxIter',50); N1=N+1; c=180/pi;
p=fsolve('dzrmt_f',p,optn); [f,x,y,ga]=dzrmt_f(p); gah=[ga ga(N)];
dt=p(3); t=dt*[0:N]; 
%
figure(1); clf; plot(x,y,x,y,'b.',x(N1),y(N1),'ro'); grid; xlabel('x/h')
ylabel('y/h'); axis([0 12.8 -1.6 8])
%
figure(2); clf; zohplot(t,c*gah); grid; axis([0 7 -80 80]) 
xlabel('Vt/h'); ylabel('\gamma (deg)')
	
	