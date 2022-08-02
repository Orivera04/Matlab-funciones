% Script p5_4_09a.m; cart with pendulum - ANALYTIC SOLN; x=[th q v y]';
% first four eqns. are final BCs, second four eqns. are initial BCs;
%                                                         2/94, 7/15/02
%
tf=[2 10 20]*pi; ep=.5; xf=[0 0 0 1]'; x0=[0 0 0 0]'; M=zeros(8);
for j=1:3,   
 T=tf(j); a=cos(T); b=sin(T);
 M(1,:)=[-T*b/2 T*a/2 -T -1 a b 0 0];
 M(2,:)=[-(b+T*a)/2 (a-T*b)/2 -1  0 -b a 0 0];
 M(3,:)=[b-ep*(b-T*a)/2  -a+ep*(a+T*b)/2 (1-ep)*T^2/2 (1-ep)*T  ...
       ep*b  -ep*a 1 0];
 M(4,:)=[-a+ep*(a+T*b/2) -b+ep*(b-T*a/2) (1-ep)*T^3/6 (1-ep)*T^2/2 ...
       -ep*a -ep*b T 1];
 M(5,:)=[0  0   0 -1 1 0 0 0];  M(6,:)=[0 1/2 -1  0 0 1 0 0];
 M(7,:)=[0 -1+ep/2 0 0  0 -ep 1 0];  M(8,:)=[-1+ep 0 0 0 -ep 0  0 1];
 A=M\[xf; x0];
 for i=1:101, t=T*(i-1)/100; a=cos(t); b=sin(t);
  u(i)=[a b t 1 0 0 0 0]*A; th(i)=[-t*b/2 t*a/2 -t -1 a b 0 0]*A;
  y(i)=[-a+ep*(a+t*b/2) -b+ep*(b-t*a/2) (1-ep)*t^3/6 (1-ep)*t^2/2 ...
        -ep*a -ep*b t 1]*A; t1(i)=t;
 end; t1=t1/(2*pi);
 figure(j); clf; subplot(211), plot(t1,y); grid; ylabel('y')
 subplot(212), plot(t1,th,t1,u,'-'); grid;  xlabel('t/2\pi')
 legend('u','\theta');
end


