%REGOB	Simulation script for observer-based digital regulator.
%	This script simulates the response of a discrete-time regulator 
%	to a nonzero initial state. A full-order observer is used to
%	estimate the state vector from the measured plant output.
%
%  INPUTS:
%
%  phi,gamma,c  ZOH equivalent plant model.
%  x0           Initial state of the plant.
%  T            Sampling interval.
%  L            Regulator feedback gains.
%  K            Observer gains
%  ftime        Simulate from 0 to ftime seconds.
%
%  OUTPUTS: 
%
%  x         Matrix of state vectors, column 1 is x0.
%  xhat      Matrix of observer state vectors.
%  u         Matrix of inputs to the plant.
%  y         Matrix of outputs of the plant.
%  t1        Time axis vector for plotting.  Use REGOBP to plot results.

%            T.Flint 7/92
%            Modified by R.J. Vaccaro   1/94,11/98

clear x u xhat y;
kf_=ceil(ftime/T);
x(:,1)=x0;
y(:,1)=c*x0;
u(:,1)=-L*x0;
xhat(:,1)=c\y(:,1);
for k_=1:kf_-1
  x(:,k_+1)=phi*x(:,k_)+gamma*u(:,k_);
  y(:,k_+1)=c*x(:,k_+1);
  xhat(:,k_+1)=(phi-K*c)*xhat(:,k_)+gamma*u(:,k_)+K*y(:,k_);
  u(:,k_+1)=-L*xhat(:,k_+1);
end
fprintf('REGOB simulation finished.  Use REGOBP to plot results.\n')
t1=T*[0:kf_-1];

clear k_ kf_
%___________________________ END OF REGOB.M _______________________________


