% Script p5_4_14.m; insertion of a S/C at the Sun-Earth L2 point
% using a solar sail; s=[x xd y yd]'; time in 1/n, n=orbit rate 
% of earth; (x,y) in units of 1.51*10^6 km (distance Earth to L2
% point); 2J=int(th^2)dt, sf=0;                    7/97, 7/24/02
%
flg=1; b1=12.762; b2=4.914; c=1.948; B=[0 0 0 c]'; R=1; 
Q=zeros(4); A=[0 1 0 0; b1 0 0 2; 0 0 0 1; 0 -2 -b2 0]; 
N=zeros(4,1); s0=[0 0 -.01 0]'; tf=pi/2; Ns=50; Mf=eye(4);
Sf=zeros(4); psi=[0 0 0 0]'; 
if flg==1, [s,th,t]=tlqh(A,B,Q,N,R,tf,s0,Sf,Mf,psi,Ns);
elseif flg==2,  t1=.9*tf; tol=1e-4; 
 [s,th,t]=tlqhr(A,B,Q,N,R,tf,s0,Sf,Mf,psi,t1,tol);
end
%
figure(1); clf; subplot(211), plot(t/tf,th); grid
ylabel('\theta (rad)'); subplot(212), plot(t/tf,s([1 3],:));
grid; xlabel('nt'); legend('x','y',4); ylabel('1.51*10^6 km')
%
figure(2); clf; plot(s(3,:),s(1,:),-.01,0,'ro',0,0,'ro');
grid; xlabel('y/l'); ylabel('x/l'); axis('square')
axis([-.012 .002 -.008 .006]) 	  
 
