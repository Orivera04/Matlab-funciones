% Script p5_2_10c.m; cart with an inverted pendulum using analytical
% solution; s=[th q v y]'; A=[A1,...,A8]'; first 4 eqns. are initial
% b.c.'s; second 4 eqns. are final b.c.'s;             7/97, 3/31/02
%
tf1=[6 30]; 
for j=1:2,
  tf=tf1(j); ep=.5; x0=[0 0 0 0]'; xf=[0 0 0 1]';
  sth=1e4; sq=sth; sv=sq; sy=sv; T=tf; a=exp(-T); 
  M(1,:)=[   T*a/2   -T/2    T 1  a 1 0 0];
  M(2,:)=[a*(1-T)/2 -(1+T)/2 1 0 -a 1 0 0];
  M(3,:)=[-a+ep*a*(1+T)/2  1-ep*(1-T)/2  (1-ep)*T^2/2 ...
             (1-ep)*T ep*a -ep 1 0];
  M(4,:)=[ a-ep*a*(1+T/2)  1-ep*(1-T/2)  (1-ep)*T^3/6 ...
        (1-ep)*T^2/2 -ep*a -ep T 1];
  M(5,:)=[ 0    0  0 1  1 a 0 0];
  M(6,:)=[1/2 -a/2 1 0 -1 a 0 0];
  M(7,:)=[-1+ep/2  a*(1-ep/2)  0 0  ep -ep*a 1 0];
  M(8,:)=[ 1-ep    a*(1-ep)    0 0 -ep -ep*a 0 1];
  b=[x0; xf]; A=M\b;
  for i=1:101, t=T*(i-1)/100; a=exp(-t); b=exp(t-T);
    u(i)=[a b t 1 0 0 0 0]*A;
    th(i)=[t*a/2 -t*b/2 t 1 a b 0 0]*A;
    y(i)=[a-ep*a*(1+t/2) b-ep*b*(1-t/2) (1-ep)*t^3/6 ...
     (1-ep)*t^2/2 -ep*a -ep*b t 1]*A; 
    t1(i)=T-t;
  end
  %
  figure(j); clf; subplot(211), plot(t1,y); grid; 
  ylabel('Cart Position y'); subplot(212), plot(t1,th,t1,u,'-');
  grid; xlabel('Normalized Time'); legend('Force u','Theta');
end
