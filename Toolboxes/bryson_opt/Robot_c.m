function [c,ceq,us,ue]=robot_c(p,N,D)
% Subroutine for Pb. 9.3.14; constraints for min time pick-and-place
% motion of two-link robot arm; time in units of tc=sqrt(m*L^2/Tmax),
% (oms,ome) in 1/tc;                              12/96, 9/97, 4/13/98 
%
% Initial guesses of oms(t), ome(t), the(1), and tf:
oms=[0 p(1:N-1) 0]; ome=[0 p(N:2*N-2) 0]; the(1)=p(2*N-1); tf=p(2*N);
dt=tf/N; 
omsb=(oms(2:N+1)+oms(1:N))/2;  omeb=(ome(2:N+1)+ome(1:N))/2;
omsd=(oms(2:N+1)-oms(1:N))/dt; omed=(ome(2:N+1)-ome(1:N))/dt;
%
% Integrate to find ths(t) and the(t): 
t=[0:dt:tf]; ths(1)=0;
for i=1:N,
  ths(i+1)=ths(i)+omsb(i)*dt; the(i+1)=the(i)+(omeb(i)-omsb(i))*dt;
end; theb=(the(2:N+1)+the(1:N))/2;
%
% Constraint on distance traveled by tip: 
d(1)=cos(ths(N+1))+cos(ths(N+1)+the(N+1))-1-cos(the(1));
d(2)=sin(ths(N+1))+sin(ths(N+1)+the(N+1))-sin(the(1)); ceq=norm(d)-D;
%
% Control constraints:
mu=1; uemax=1; usmax=1; A=mu*ones(2,2)+[4/3 1/2; 1/2 1/3]; 
for i=1:N,
  b=(mu+1/2)*sin(theb(i));
  ue1=A(2,1)*omsd(i)*cos(theb(i))+A(2,2)*omed(i)+b*omsb(i)^2;
  c(i)=abs(ue1)-uemax;      
  us1=ue1+A(1,1)*omsd(i)+A(1,2)*omed(i)*cos(theb(i))-b*omeb(i)^2;
  c(i+N)=abs(us1)-usmax; us(i)=us1; ue(i)=ue1;  
end
