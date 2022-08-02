% ETSROB Error-driven, reduced-order-observer-based digital tracking system.
%	Such tracking systems can be be designed using the function RTS.
%
% INPUTS:
%
% phi,gamma,c   ZOH equivalent plant model.
% f             feedthrough from disturbance to plant output
% e             Input vector (matrix for multivariable) for disturbances
% g             Feedforward gain (vector of gains for multivariable plant).
%               Can only be used if number of inputs equals number of outputs
% x0            Initial state of the Plant.
% T             Sampling interval.
% L1,L2         Partition of feedback gains calculated for the design system.
% ftime         Simulate from 0 to ftime seconds.
% ref, dist     Matrices which specify reference and disturbance signals.
%               These signals can be generated with the SIGGEN  function.
%
% OUTPUTS: 
%
% y         Matrix of plant outputs 
% x         Matrix of state vectors, column 1 is x0.
% u         Matrix of inputs to the plant.
% t1        Time axis vector for plotting.

%           R.J. Vaccaro 10/93
%___________________________________________________________________________


[j,inp]=size(gamma);
M=length(c(:,1));
kf=ceil(ftime/T);
t1=T*[0:kf-1];
N=length(phi(:,1));
m=N-length(F(:,1));
Lb=L1/P;
clear xa x u x2hat z xhat;
x(:,1)=x0;
xa(:,1)=zeros(max(size(gammaa)),1);
y(:,1)=c*x0+f*dist(:,1);
z(:,1)=P(m+1:N,:)*(c\(y(:,1)-ref(:,1)))-K*y(:,1);
x2hat(:,1)=z(:,1)+K*(y(:,1)-ref(:,1));
xhat(:,1)=P\[y(:,1)-ref(:,1);x2hat(:,1)];
u(:,1)=-L1*xhat(:,1)+L2*xa(:,1);
if inp==M
  u(:,1)=u(:,1)+g*ref(:,1);
end
x_c=setstr([32*ones(1,55)]);
   x_c=[x_c,'done',13];
   fprintf(x_c)
inc=55/kf;
for k=1:kf-1,
kkk=fix(k*inc);
        x_c=setstr([46*ones(1,kkk) 32*ones(1,55-kkk)]);
        x_c=[x_c,13];
        fprintf(x_c)
   x(:,k+1)=phi*x(:,k)+gamma*u(:,k)+e*dist(:,k);
   z(:,k+1)=F*z(:,k)+G*(y(:,k)-ref(:,k))+H*u(:,k);	
   xa(:,k+1)=phia*xa(:,k)+gammaa*(ref(:,k)-y(:,k));
   y(:,k+1)=c*x(:,k+1)+f*dist(:,k+1);
   x2hat(:,k+1)=z(:,k+1)+K*(y(:,k+1)-ref(:,k+1));
   xhat(:,k+1)=P\[y(:,k+1)-ref(:,k+1);x2hat(:,k+1)];
   u(:,k+1)=-L1*xhat(:,k+1)+L2*xa(:,k+1);
if inp ==M
   u(:,k+1)=u(:,k+1)+g*ref(:,k);
end
end
fprintf('ETSROB simulation finished.  Use TSOBP to plot results.\n')

%___________________________ END OF ETSROB.M _______________________________


