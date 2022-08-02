function [f,a,v,y]=svic_f(p,N,el)                          
% Subroutine for Pb. 9.3.8; performance index;      11/94, 9/10/02
% 
v(1)=1; v(N+1)=-1; y(1)=0; y(N+1)=0; J(1)=0; dt=1/N;   
for i=2:N, v(i)=p(i-1); end                % Estimate of v history
for i=1:N,
  a(i)=(v(i+1)-v(i))/dt; vb=(v(i+1)+v(i))/2;
  y(i+1)=y(i)+dt*vb; J(i+1)=J(i)+dt*a(i)^2;
end
f=J(N+1);                                      % Performance index 