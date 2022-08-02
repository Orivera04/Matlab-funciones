function [Hu,phi,la0,psi]=odehnu(name,u,s,tf,nu)
% Backward Runge-Kutta integration, store Hu(i), phi, la0, psi;
% Subroutine for FOPCN;  				                    2/25/97
%
N1=length(u); N=N1-1; dt=tf/N;
[Phi,Phis]=feval(name,0,s(:,N1),tf,2); nt1=length(Phi); 
phi=Phi(1); psi=Phi([2:nt1]);    
la=Phis'*[1;nu']; 
for i=N1:-1:2,
 if i==2,        u2=(3*u(:,1)+6*u(:,2)-u(:,3))/8;
                 s2=(3*s(:,1)+6*s(:,2)-s(:,3))/8;
 elseif i==N1,   u2=(3*u(:,i)+6*u(:,i-1)-u(:,i-2))/8;
                 s2=(3*s(:,i)+6*s(:,i-1)-s(:,i-2))/8;
 else            u2=(-u(:,i-2)+9*u(:,i-1)+9*u(:,i)-u(:,i+1))/16;
                 s2=(-s(:,i-2)+9*s(:,i-1)+9*s(:,i)-s(:,i+1))/16;
 end;
 t1=(i-1)*dt;    t2=t1-dt/2;      t3=t1-dt;
 [fs,fu]=feval(name,u(:,i),s(:,i),t1,3);  Hu(i)=la'*fu;
 d1=fs'*la;      l2=la+dt*d1/2;
 [fs,fu]=feval(name,u2,s2,t2,3);
 d2=fs'*l2;      l3=la+dt*d2/2;   d3=fs'*l3;  l4=la+dt*d3;
 [fs,fu]=feval(name,u(:,i-1),s(:,i-1),t3,3);
 d4=fs'*l4;
 la=la+dt*(d1+2*d2+2*d3+d4)/6;
end;
la0=la;
[fs,fu]=feval(name,u(:,1),s(:,1),0,3);  Hu(1)=la'*fu;
	


