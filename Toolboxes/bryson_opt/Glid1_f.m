function [f,x,y,ps,V,sg,tf]=glid1_f(p)
% Subroutine for p9_3_16.m; max time glide at const. altitude; 8/10/01
%
E=20; om=.23; ymax=.4; N=40;
%
% Estimates of V(t), ps(t), tf:
V=[1 p(1:N-1) .3575]; ps=[0 p(N:2*N-1)]; tf=p(2*N); dt=tf/N;
Vb=(V(2:N+1)+V(1:N))/2; Vd=(V(2:N+1)-V(1:N))/dt;
psb=(ps(2:N+1)+ps(1:N))/2; psd=(ps(2:N+1)-ps(1:N))/dt;
%
% sg(t) from V & derivative of ps:
sg=atan(Vb.*psd);
%
% x(t), y(t) from integrations of V and ps:   
y(1)=0; x(1)=-2;  
for i=1:N,
   y(i+1)=y(i)+Vb(i)*sin(psb(i))*dt; 
   x(i+1)=x(i)+Vb(i)*cos(psb(i))*dt;
end 
%
% Performance index:
f=-tf;
   
   
