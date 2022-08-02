%REGSF	Simulation script for digital state-feedback regulator.
%	This script simulates the response of a discrete-time 
%	regulator to a nonzero initial state.
%
%  INPUTS:
%
%  phi,gamma ZOH equivalent plant model.
%  x0        Initial state of the plant.
%  T         Sampling interval.
%  L         Regulator feedback vector.
%  ftime     Simulate from 0 to ftime seconds.
%
%  OUTPUTS: 
%
%  x         Matrix of state vectors, column 1 is x0.
%  u         Matrix of inputs to the plant.
%  t1        Time axis vector for plotting.  Use REGSFP to plot results.

%            T.Flint 7/92
%            Modified by R.J. Vaccaro   10/93,11/98


clear x u;
kf_=ceil(ftime/T);
x(:,1)=x0;
u(:,1)=-L*x0;
for k_=1:kf_-1
  x(:,k_+1)=phi*x(:,k_)+gamma*u(:,k_);
  u(:,k_+1)=-L*x(:,k_+1);
end
fprintf('REGSF simulation completed.  Use REGSFP to plot the results\n')
t1=T*[0:kf_-1];

clear k_ kf_

%_________________________ END OF REGSF.M ___________________________


