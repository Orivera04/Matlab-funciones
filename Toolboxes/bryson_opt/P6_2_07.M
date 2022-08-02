% Script p6_2_07.m; station-keeping for S/C at Earth-Moon L1 point using
% radial thrusters; s=[x xdot y ydot]'; time in 1/n, n=orbit rate of moon;
% J=integral(Q*y^2+u^2)dt;                                  12/92, 7/17/02
%
be=5.148; B=[0 1 0 0]'; C=[0 0 1 0]; R=1; A=[0 1 0 0; 2*be+1 0 0 2; ...
      0 0 0 1; 0 -2 -(be-1) 0]; Q=10.^[0:.25:5]; N=length(Q);
%
figure(1); clf; for i=1:N; [k,S,e]=lqr(A,B,C'*Q(i)*C,R);
   plot(real(e),imag(e),'x'); hold on; end; grid; axis([-6 0 0 6])
axis('square'); xlabel('Real(ev)'); ylabel('Imag(ev)')
Q2=1000; [k1,S,e2]=lqr(A,B,C'*Q2*C,R); plot(real(e2),imag(e2),'rx');
Q3=1e12; [k,S,z]=lqr(A,B,C'*Q3*C,R); plot(real(z),imag(z),'ro');
hold off; title('S/C at Earth-Moon L1 Point; RL vs. Q/R')
% 	
t=[0:.05:5]'; u=zeros(1,length(t)); x0=[0 0 0 1]'; 
[y,x]=lsim(A-B*k1,B,C,0,u,t,x0); u=-x*k1';
%
figure(2); clf; subplot(211), plot(t,[x(:,1) x(:,3)]); grid
ylabel('n*x/vo n*y/vo'); subplot(212), plot(t,u); 
grid; ylabel('a_y/(n*vo)'); xlabel('nt') 
title('S/C at Earth-Moon L1 Point; Response to ydot(0)=vo')
 
