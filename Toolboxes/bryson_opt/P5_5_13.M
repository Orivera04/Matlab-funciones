% Script p5_5_13.m; insertion of a S/C at the Earth-Moon L1 point 
% using TDLQH; s=[x u y v]'; time in 1/n, n=orbit rate of moon, a=
% radial specific thrust in units of l*n^2, (x,y) in units of l=
% distance earth to L1;                                7/97, 7/25/02
%
flg=1; be=5.148; B=[0 1 0 0]'; psi=[0 0 0 0]'; Qd=zeros(4); 
A=[0 1 0 0; 2*be+1 0 0 2; 0 0 0 1; 0 -2 -(be-1) 0]; Nd=zeros(4,1); 
Rd=1; s0=[0 0 -.01 0]'; tf=pi/4; Ns=50; Mf=eye(4); Sf=zeros(4); 
Ts=tf/Ns; [Ad,Bd]=c2d(A,B,Ts); nf=5; 
if flg==1, [s,a]=tdlqh(Ad,Bd,Qd,Nd,Rd,s0,Sf,Mf,psi,Ts,Ns); 
elseif flg==2, [s,a]=tdlqhr(Ad,Bd,Qd,Nd,Rd,s0,Sf,Mf,psi,Ts,Ns,nf); 
end; ah=[a a(Ns)]; t=[0:1/Ns:1];
%
figure(1); clf; subplot(211), zohplot(t,ah); grid; ylabel('a/l*n^2')
subplot(212), plot(t,s(1,:),t,s(3,:),'r--'); grid; xlabel('t/t_f')
legend('x/l','y/l',2)
%
figure(2); clf; plot(s(3,:),s(1,:),-.01,0,'ro',0,0,'ro'); grid
xlabel('y/l'); ylabel('x/l'); axis([-.025 .025 -.03 .02])
axis('square')

 
