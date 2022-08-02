% Script rosstest.m; Conway-Ross 2nd order LQ pb.;         8/12/02
%
Mf=[1 -2.694528]; Sf=zeros(2); psi=-1.155356; Ns=100; x0=[0 0]';
tf=2; A=[0 1; 0 -1]; B=[0 1]'; Q=zeros(2); N=[0 0]'; R=1;
[x,u,t]=tlqh(A,B,Q,N,R,tf,x0,Sf,Mf,psi,Ns);
J=trapz(t,u.^2);
%
% Analytical solution:
ua=exp(t)/4-1/2; x1=-3*exp(-t)/8+exp(t)/8-t/2+1/4;
x2=3*exp(-t)/8+exp(t)/8-1/2; Ja=.577678; J-Ja
%
figure(1); clf; subplot(211), plot(t,x(1,:)-x1,t,x(2,:)-x2,'r--');
grid; legend('x_1-x_{1a}','x_2-x_{2a}',3), subplot(212)
plot(t,u-ua); grid; ylabel('u-u_a'); xlabel('Time')