% Script p5_4_10a.m; HTC of cart with inverted pendulum; semi-analytical
% soln; first 4 eqns. are final BCs; second 4 eqns. are initial BCs;
%                                                          2/94, 7/15/02
%
tf=[6 15 30]; ep=.5; s0=[0 0 0 0]'; sf=[0 0 0 1]'; 
for i=1:3,             
 T=tf(i); a=exp(-T); 
 M(1,:)=[   T*a/2   -T/2    T 1  a 1 0 0];
 M(2,:)=[a*(1-T)/2 -(1+T)/2 1 0 -a 1 0 0];
 M(3,:)=[-a+ep*a*(1+T)/2 1-ep*(1-T)/2 ...
        (1-ep)*T^2/2 (1-ep)*T ep*a -ep 1 0];
 M(4,:)=[ a-ep*a*(1+T/2) 1-ep*(1-T/2) ...
       (1-ep)*T^3/6 (1-ep)*T^2/2  -ep*a -ep T 1];
 M(5,:)=[ 0    0  0 1  1 a 0 0];
 M(6,:)=[1/2 -a/2 1 0 -1 a 0 0];
 M(7,:)=[-1+ep/2  a*(1-ep/2)  0 0 ep -ep*a 1 0];
 M(8,:)=[ 1-ep    a*(1-ep)    0 0 -ep -ep*a 0 1];
 b=[sf; s0]; A=M\b;
 for j=1:101, x=T*(j-1)/100; a=exp(-x); b=exp(x-T);
  u(j)=[a b x 1 0 0 0 0]*A;
  th(j)=[x*a/2 -x*b/2 x 1 a b 0 0]*A;
  y(j)=[a-ep*a*(1+x/2) b-ep*b*(1-x/2) (1-ep)*x^3/6 ...
      (1-ep)*x^2/2  -ep*a -ep*b x 1]*A; 
  t(j)=x;
 end
 figure(i); clf; subplot(211), plot(t,y); grid
 ylabel('Cart Position y') 
 subplot(212), plot(t,th,t,u,'-'); grid
 xlabel('t'); legend('Force u','Angle \theta')
end
