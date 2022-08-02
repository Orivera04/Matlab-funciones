function [Hu,phi,psi,la0]=odeh(name,u,s,tf)
%ODEH - Bkwd 4th order fixed stepsize Runge-Kutta integ. of adjoint
%[Hu,phi,psi,la1]=odeh(name,u,s,tf)
% equations with forcing functions u(t), s(t) where fs=fs(s,u),
% fu=fu(s,u), storing Hu; function file 'name' contains [Phi,Phis]
% for flg=2 and [fs,fu] for flg=3;                    4/97, 1/14/98 
%
[nc,N1]=size(u); N=N1-1; dt=tf/N; dum=zeros(nc,1); 
[Phi,Phis]=feval(name,dum,s(:,N1),tf,2); nt1=length(Phi);  
phi=Phi(1); psi=Phi([2:nt1]); la=Phis'; 
for i=N1:-1:2
  if i==2,        u2=(3*u(:,1)+6*u(:,2)-u(:,3))/8;
                  s2=(3*s(:,1)+6*s(:,2)-s(:,3))/8;
  elseif i==N1,   u2=(3*u(:,i)+6*u(:,i-1)-u(:,i-2))/8;
                  s2=(3*s(:,i)+6*s(:,i-1)-s(:,i-2))/8;
  else            u2=(-u(:,i-2)+9*u(:,i-1)+9*u(:,i)-u(:,i+1))/16;
                  s2=(-s(:,i-2)+9*s(:,i-1)+9*s(:,i)-s(:,i+1))/16;
  end
  t1=(i-1)*dt;    t2=t1-dt/2;      t3=t1-dt;
  [fs,fu]=feval(name,u(:,i),s(:,i),t1,3); A=la'*fu;
  for j1=1:nc, for j2=1:nt1, Hu((j1-1)*nt1+j2,i)=A(j2,j1);
  end; end
  d1=fs'*la;      l2=la+dt*d1/2;
  [fs,fu]=feval(name,u2,s2,t2,3);
  d2=fs'*l2;      l3=la+dt*d2/2;   d3=fs'*l3;  l4=la+dt*d3;
  [fs,fu]=feval(name,u(:,i-1),s(:,i-1),t3,3);  d4=fs'*l4;
  la=la+dt*(d1+2*d2+2*d3+d4)/6;
end; la0=la; 
[fs,fu]=feval(name,u(:,1),s(:,1),0,3); A=la'*fu;        
for j1=1:nc, for j2=1:nt1,
  Hu((j1-1)*nt1+j2,1)=A(j2,j1);
end; end
