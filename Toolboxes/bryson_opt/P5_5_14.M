% Script p5_5_14.m; insertion of a solar sail S/C at the Sun-Earth L2
% point using TDLQH (flg=1) or TDLQHR (flg=2); s=[x xdot y ydot]'; time
% in 1/n, n=orbit rate of earth; (x,y) in units of 1.51*10^6 km (dist. 
% Earth to L2 point); 2J=int(th^2)dt;                     7/97, 7/25/02
%
flg=1; b1=12.762; b2=4.914; c=1.948; B=[0 0 0 c]'; Rd=1; Qd=zeros(4); 
A=[0 1 0 0; b1 0 0 2; 0 0 0 1; 0 -2 -b2 0]; Nd=zeros(4,1);
s0=[0 0 -.01 0]'; tf=pi/2; Ns=50; Mf=eye(4); Sf=zeros(4); nf=5; 
psi=[0 0 0 0]'; Ts=tf/Ns; [Ad,Bd]=c2d(A,B,Ts); t=[0:1/Ns:1];
if flg==1, [s,th]=tdlqh(Ad,Bd,Qd,Nd,Rd,s0,Sf,Mf,psi,Ts,Ns);
elseif flg==2, [s,th]=tdlqhr(Ad,Bd,Qd,Nd,Rd,s0,Sf,Mf,psi,Ts,Ns,nf);
end; thh=[th th(Ns)]; 
%
figure(1); clf; subplot(211), zohplot(t,thh); grid 
ylabel('\theta (rad)'); subplot(212), plot(t,s(1,:),t,s(3,:),'r--');
legend('x','y',4); grid; xlabel('nt') 
%
figure(2); clf; plot(s(3,:),s(1,:),-.01,0,'ro',0,0,'ro'); grid
xlabel('y/l'); ylabel('x/l'); axis('square')
axis([-.012 .002 -.008 .006]) 	  
 
