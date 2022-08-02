function [t,s]=odeu(name,u,s0,tf)
% Forward 4th order fixed step-size Runge-Kutta integration with
% vector forcing function u(t); sdot=f(s,u); function file
% 'name' contains the function f(s,u) for flg=1;            9/97
%
[nc,N1]=size(u); N=N1-1; t=tf*[0:1/N:1]; dt=tf/N; s(:,1)=s0; 
for i=1:N,  
 if i==1,        u2=(3*u(:,1)+6*u(:,2)-u(:,3))/8;
 elseif i==N,    u2=(3*u(:,N1)+6*u(:,N)-u(:,N-1))/8;
 else            u2=(-u(:,i-1)+9*u(:,i)+9*u(:,i+1)-u(:,i+2))/16;
 end
 t1=(i-1)*dt;    t2=t1+dt/2;  t3=t1+dt;
 s1=s(:,i);      f1=feval(name,u(:,i),s1,t1,1);
 s2=s1+dt*f1/2;  f2=feval(name,u2,s2,t2,1);
 s3=s1+dt*f2/2;  f3=feval(name,u2,s3,t2,1);
 s4=s1+dt*f3;    f4=feval(name,u(:,i+1),s4,t3,1);
 s(:,i+1)=s1+dt*(f1+2*f2+2*f3+f4)/6;
end

 

