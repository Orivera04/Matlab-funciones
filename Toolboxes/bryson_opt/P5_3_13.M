% Script p5_3_13.m; insertion of a S/C at the Earth-Moon L1 point using
% radial thrusters; s=[x u y v]'; time in 1/n, n=orbit rate of moon, 
% a=radial specific thrust in units of l*n^2, (x,y) in units of 
% l=distance earth to L1;                                  7/97, 7/3/02
%
be=5.148; B=[0 1 0 0]'; tf=pi/4; N=50; Ts=tf/N; A=[0 1 0 0; ...
  2*be+1 0 0 2; 0 0 0 1; 0 -2 -(be-1) 0]; [Ph,Ga]=c2d(A,B,Ts);
Qd=zeros(4); Nd=zeros(4,1); Rd=1; x0=[0 0 -.01 0]'; Mf=eye(4);
Qf=3e8; psi=[0 0 0 0]'; [s,a]=tdlqs(Ph,Ga,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,N);
t=tf*[0:1/N:1]; ah=[a a(N)]; 
%
figure(1); clf; subplot(211), zohplot(t/tf,ah); grid 
ylabel('a/l*n^2'); subplot(212), plot(t/tf,s([1 3],:)); grid
xlabel('t/tf'); ylabel('x/l and y/l')
%
figure(2); clf; plot(s(3,:),s(1,:),-.01,0,'ro',0,0,'ro'); grid 
xlabel('y/l'); ylabel('x/l'); axis([-.025 .025 -.03 .02])
axis('square')
 
