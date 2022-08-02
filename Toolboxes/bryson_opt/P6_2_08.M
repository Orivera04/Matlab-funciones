% Script p6_2_08.m; S/C station-keeping at Sun-Earth L2 point using a 
% solar sail; s=[x xdot y ydot]'; time in 1/n, n=orbit rate of earth; 
% (x,y) in units of 1.51*10^6 km (distance Earth to L2 point);
% J=integral(Q*y^2+u^2)dt;                             12/96, 7/17/02
%
b1=12.762; b2=4.914; c=1.948; A=[0 1 0 0; b1 0 0 2; 0 0 0 1; 0 -2 ...
  -b2 0]; B=[0 0 0 c]'; C=[0 0 1 0]; D=0; R=1; n=ss2tf(A,B,C,D,1);
z=roots(n([3:5])); Q=10.^[0:.5:4]; N=length(Q); ev=zeros(4,N);
for i=1:N, [k,S,ev(:,i)]=lqr(A,B,C'*Q(i)*C,R); end 
%
figure(1); clf; plot(real(ev),imag(ev),'x'); grid; axis([-7 1 0 8])
axis('square'); hold on; xlabel('Real(ev/n)'); ylabel('Imag(ev/n)')
Q2=100; [k,S,e2]=lqr(A,B,C'*Q2*C,R); plot(real(e2),imag(e2),'rx');
hold off; title('S/C Near the Sun-Earth L2 Point; RL vs. Q/R')
%
figure(2); clf; plot(real(ev),imag(ev),'x'); grid
axis([-3.7 -3.1 0 .6]); axis('square'); xlabel('Real(ev/n)')
ylabel('Imag(ev/n)'); hold on; plot(real(z),imag(z),'ro');
hold off; text(-3.52,.02,'Zero & Refl. Zero')
% 	
t=[0:.02:2]'; u=zeros(1,length(t)); x0=[0 0 .01 0]'; 
[y,x]=lsim(A-B*k,B,C,0,u,t,x0); u=-x*k';
%
figure(3); clf; subplot(211), H=plot(t,x(:,1),t,x(:,3),'r--'); grid
legend(H,'x','y'); ylabel('1.51*10^6 km'); axis([0 2 -.002 .014])
title('S/C at the Sun-Earth L2 Point; y(0)=.01'); subplot(212),
plot(t,u); grid; axis([0 2 -.02 .14]); ylabel('\theta (rad)')
xlabel('nt')  
 
