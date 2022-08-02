% Script p5_4_13.m; insertion of a S/C at the Earth-Moon L1 point 
% using radial thrusters; s=[x u y v]'; time in 1/n, n=orbit rate 
% of moon, a=radial specific thrust in units of l*n^2, (x,y) in 
% units of l=dist. earth to L1;                       7/97, 7/24/02
%
flg=1; be=5.148; A=[0 1 0 0; 2*be+1 0 0 2; 0 0 0 1; 0 -2 -(be-1) 0]; 
B=[0 1 0 0]'; psi=[0 0 0 0]'; Q=zeros(4); N=zeros(4,1); R=1;
s0=[0 0 -.01 0]'; tf=pi/4; Ns=50; Mf=eye(4); Sf=zeros(4); 
if flg==1, [s,a,t]=tlqh(A,B,Q,N,R,tf,s0,Sf,Mf,psi,Ns);
elseif flg==2, t1=.8*tf; tol=1e-4; 
[s,a,t]=tlqhr(A,B,Q,N,R,tf,s0,Sf,Mf,psi,t1,tol);
end
%
figure(1); clf; subplot(211), plot(t/tf,a); grid; ylabel('a/l*n^2')
subplot(212), plot(t/tf,s([1 3],:)); grid; xlabel('t/t_f')
legend('x/l','y/l',2)
%
figure(2); clf; plot(s(3,:),s(1,:),-.01,0,'ro',0,0,'ro'); grid  
xlabel('y/l'); ylabel('x/l'); axis([-.025 .025 -.03 .02])
axis('square')

 
