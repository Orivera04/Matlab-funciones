function [ceq,c]=dtdp_c(th,s0,tf,N,gv,yf)	       
% Subroutine for e03_2_2 and p3_1_09a; DTDP with gravity for max uf to 
% vf=0 & spec. yf; t in tf, (u,v) in a*tf; (x,y) in a*tf^2; s=[u v y x]';
% th=control; x is an ignorable coord; included for trajectory plot;
%                   	                         11/94, 6/98, 3/13/02  
%
u(1)=s0(1); v(1)=s0(2); y(1)=s0(3); x(1)=s0(4); dt=tf/N; 
for i=1:N, si=sin(th(i)); co=cos(th(i)); 
 u(i+1)=u(i)+dt*co; v(i+1)=v(i)+dt*si-gv*dt;
 y(i+1)=y(i)+dt*v(i)+dt^2*si/2-.5*gv*dt^2; x(i+1)=x(i)+dt*u(i)+dt^2*co/2;
end
ceq=[]; c=[v(N+1) y(N+1)-yf]'; 

