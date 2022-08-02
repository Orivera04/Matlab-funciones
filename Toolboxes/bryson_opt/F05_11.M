% Script f05_11.m; min integral-square control of a cart  w. an 
% inverted pendulum from x(0) to x(tf) in time tf = 30; uses
% (modified) modal method of Bryson & Hall (1980) for repeated
% eigenvalues of EL eqns; x = [th thdot ydot y]';
% A = [A1, - - - A8]'; M*A=[x(tf); x(0)]; first 4 eqns. are final
% b.c.'s; second 4 eqns. are initial b.c.'s;         2/94, 4/3/02

tf=30; ep=.5; xf=[0 0 0 0]'; xo=[0 0 0 -1]';        
T=tf; a=exp(-T); 
M(1,:)=[   T*a/2   -T/2    T 1  a 1 0 0];
M(2,:)=[a*(1-T)/2 -(1+T)/2 1 0 -a 1 0 0];
M(3,:)=[-a+ep*a*(1+T)/2  1-ep*(1-T)/2  (1-ep)*T^2/2 (1-ep)*T ...
         ep*a -ep 1 0];
M(4,:)=[ a-ep*a*(1+T/2)  1-ep*(1-T/2)  (1-ep)*T^3/6 (1-ep)*T^2/2 ...
        -ep*a -ep T 1];
M(5,:)=[ 0    0  0 1  1 a 0 0];
M(6,:)=[1/2 -a/2 1 0 -1 a 0 0];
M(7,:)=[-1+ep/2  a*(1-ep/2)  0 0  ep -ep*a 1 0];
M(8,:)=[ 1-ep    a*(1-ep)    0 0 -ep -ep*a 0 1];
b=[xf; xo]; A=M\b;
for i=1:101, t=T*(i-1)/100; a=exp(-t); b=exp(t-T);
  u(i)=[a b t 1 0 0 0 0]*A;
  th(i)=[t*a/2 -t*b/2 t 1 a b 0 0]*A;
  y(i)=[a-ep*a*(1+t/2) b-ep*b*(1-t/2) (1-ep)*t^3/6 (1-ep)*t^2/2 ...
        -ep*a -ep*b t 1]*A; 
  t1(i)=t;
end
% K1=inv(M); K=-[1 exp(-T) 0 1]*K1([1:4],[5:8]);
% Feedback gain (u=-K*xo) at t = 0

figure(1); clf; subplot(211), plot(t1,y); grid 
text(1,-.2,'Cart Position y'); axis([0 30 -1.5 .5])
subplot(212), plot(t1,th,t1,u,'-'); grid
axis([0 30 -.02 .02]); xlabel('Normalized Time')
text(6,.015,'Force u'); text(2,-.01,'Pendulum Angle \theta')
%print -deps2 f05_11
