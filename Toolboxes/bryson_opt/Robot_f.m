function [f,ome,oms,the,ths,tf]=robot_f(p,N,D)
% Subroutine for Pb. 9.3.14; performance index f for min time pick-and-
% place motion of two-link robot arm; time in units of tc=sqrt(m*L^2/Tmax),
%(oms,ome) in 1/tc;                                    12/96, 9/97, 4/13/98 
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
end; %theb=(the(2:N+1)+the(1:N))/2;
%
% Performance index:
f=tf;