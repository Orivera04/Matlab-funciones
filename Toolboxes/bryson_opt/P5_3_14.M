% Script p5_3_14.m; insertion of a S/C at the Sun-Earth L2 point using 
% a solar sail & TDLQS; s=[x xd y yd]'; time in 1/n, n=orbit rate of
% earth; (x,y) in units of distance Earth to L2 point;
% 2J=sf'*Sf*sf+int(th^2)dt;                               7/97, 7/3/02
%
b1=12.762; b2=4.914; c=1.948; B=[0 0 0 c]'; A=[0 1 0 0; b1 0 0 2; ...
   0 0 0 1; 0 -2 -b2 0]; tf=pi/2; N=50; Ts=tf/N; [Ad,Bd]=c2d(A,B,Ts);
Qd=zeros(4); Nd=zeros(4,1); Rd=1; s0=[0 0 -.01 0]'; Qf=1e6; Mf=eye(4);
psi=[0 0 0 0]'; [s,th]=tdlqs(Ad,Bd,Qd,Nd,Rd,s0,Mf,Qf,psi,s0,N);
thh=[th th(N)]; t=tf*[0:1/N:1];
%
figure(1); clf; subplot(211), zohplot(t/tf,thh); grid
ylabel('\theta (rad)'); subplot(212), plot(t/tf,s([1 3],:)); grid
xlabel('nt'); ylabel('x and y (1.51*10^6 km)')
%
figure(2); clf; plot(s(3,:),s(1,:),-.01,0,'ro',0,0,'ro'); grid
xlabel('y/l'); ylabel('x/l'); axis([-.012 .002 -.008 .006])
axis('square')
	  
 
