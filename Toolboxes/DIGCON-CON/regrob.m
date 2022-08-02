%REGROB	Simulation for reduced-order-observer-based digital regulator.
%	This script simulates the response of a discrete-time regulator 
%	to a nonzero initial state. A reduced-order observer is used to
%	estimate the state vector from the measured plant output.
%	The function ROO can be used to design the reduced-order observer.
%
% INPUTS:
%
% phi,gamma     ZOH equivalent plant model.
% Cm            Measurement matrix.    
% L             Regulator feedback vector.
% F,G,H,K,P     Reduced-order observer matrices.
% x0            Initial state of the Plant.
% T             Sampling period of discete regulator.
%
% OUTPUTS: 
%
% x         Matrix of plant states, column 1 is x0.
% ym        Matrix of measurements.
% z         Matrix of internal observer states.
% xhat      Matrix of estimated states.
% u         Row vector of inputs to the plant.
% t1        Time axis vector for plotting.  Use REGROBP to plot results.

%        T.Flint 8/92
%        R.J. Vaccaro 1/94,11/98


clear u x y ym z xhat;
kf_=ceil(ftime/T);
N_=length(phi(:,1));
m_=N_-length(F(:,1));
Lb=L/P;
x(:,1)=x0;
ym(:,1)=Cm*x(:,1);
z0=P(m_+1:N_,:)*(Cm\ym(:,1))-K*ym(:,1);
xhat(:,1)=z0+K*Cm*x0;
z(:,1)=z0;
u(:,1)=-Lb*[Cm*x0;z0+K*Cm*x0];
for i_=1:kf_-1
  ym(:,i_)=Cm*x(:,i_);
  x(:,i_+1)=phi*x(:,i_)+gamma*u(:,i_);
  z(:,i_+1)=F*z(:,i_)+G*ym(:,i_)+H*u(:,i_);
  xhat(:,i_+1)=z(:,i_+1)+K*Cm*x(:,i_+1);
  u(:,i_+1)=-Lb*[Cm*x(:,i_+1);xhat(:,i_+1)];
end
ym(:,kf_)=Cm*x(:,kf_);
xhat=P\[ym;xhat];
fprintf('REGROB simulation completed.  Use REGROBP to plot results.\n')
t1=T*[0:kf_-1];

clear k_ kf_ N_ m_ i_

%__________________________ END OF REGROB.M _______________________________


