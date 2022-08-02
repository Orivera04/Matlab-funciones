% Script p5_2_09c.m; cart with a pendulum; MISC ANALYTICAL SOLUTION;
% x=[th q v y]'; A=[A1,...,A8]'; first 4 eqns. are initial b.c.'s; 
% second 4 eqns. are final b.c.'s;	                    7/97, 3/31/02
%
tf1=pi*[2 10]; ep=.5; x0=[0 0 0 0]'; xf=[0 0 0 1]'; sth=10^2; sq=sth;
sv=sq; sy=sv; 
for j=1:2, T=tf1(j); co=cos(T); si=sin(T); 
  M=[-T*si/2 T*co/2 -T -1 co si 0 0; -(si+T*co)/2 (co-T*si)/2 -1  0 ...
  -si co 0 0; si-ep*(si-T*co)/2  -co+ep*(co+T*si)/2 (1-ep)*T^2/2 ...
  (1-ep)*T  ep*si  -ep*co 1 0; -co+ep*(co+T*si/2) -si+ep*(si-T*co/2) ...
  (1-ep)*T^3/6 (1-ep)*T^2/2 -ep*co -ep*si T 1; 0  1/sth ...
  ep/(sth*(1-ep)) -1 1 0 0 0; 1/sq 1/2 -1  -ep/(sq*(1-ep)) 0 1 0 0; ...
  0 -1+ep/2 0 -1/(sv*(1-ep)) 0 -ep 1 0; -1+ep 0 1/(sy*(1-ep)) 0 -ep ...
  0  0 1]; A=M\[x0; xf];
  for i=1:101, t=T*(i-1)/100; co=cos(t); si=sin(t);
    u(i)=[co si t 1 0 0 0 0]*A; th(i)=[-t*si/2 t*co/2 -t -1 co si 0 ...
    0]*A; y(i)=[-co+ep*(co+t*si/2) -si+ep*(si-t*co/2) (1-ep)*t^3/6 ...
    (1-ep)*t^2/2  -ep*co -ep*si t 1]*A; t1(i)=(T-t)/(2*pi);
  end 
  %
  figure(j); clf; subplot(211), plot(t1,y); grid; 
  ylabel('Cart Position y'); subplot(212), plot(t1,th,'b',t1,u,'r--');
  grid; xlabel('t/(2\pi)'); legend('Force u','Angle \theta');
end 

	


