function [f,g]=dvdp_gr(ga,s0,tf,N)                            
% Subroutine for e02_2_2;                11/94, 3/23/02
%
dt=tf/N; v(1)=s0(1); x(1)=s0(2);
for i=1:N, 
   x(i+1)=x(i)+dt*v(i)*cos(ga(i))+dt^2*sin(2*ga(i))/4;
   v(i+1)=v(i)+dt*sin(ga(i));  
end
f=-x(N+1);
%
Hu=zeros(1,N); phis=[0 1]; la=phis'; 
% Backward sequencing and store Hu(i);
for i=N:-1:1, fs=[1 0; dt*cos(ga(i)) 1];
 fu=dt*[cos(ga(i)); -v(i)*sin(ga(i))+dt*cos(2*ga(i))/2];
 Hu(i)=la'*fu; la=fs'*la;
end;    
g=-Hu;
