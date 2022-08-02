% Script p3_2_1.m; DVDP for max range with gravity and 
% specified yf;                          4/97, 3/30/02
%
N=5; u0=(pi/2)*[1:-1/N:1/N]; s0=[0 0 0]'; tf=1; k=-15;
tol=1e-4; mxit=50; t=tf*[0:N]/N;
[u,s,nu,la0]=dopc('dvdpc',u0,s0,tf,k,tol,mxit);
x=s(2,:); y=s(3,:); uh=[u u(N)]; N1=N+1;
%
figure(1); clf; plot(x,-y,x,-y,'b.',x(N1),-y(N1),'ro');
grid; axis([0 .36 -.27 0]); ylabel('y/gt_f^2') 
xlabel('x/gt+f^2')
%
figure(2); clf; zohplot(t,2*uh/pi); grid; xlabel('t')
ylabel('2 \gamma / \pi');
	
	