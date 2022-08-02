%AREG.M	Simulation script for an analog regulator.
%	This is a MATLAB script that simulates the response of
%	an analog state-space regulator to a nonzero initial state.
%
% INPUTS:
%
% A,b       State-space plant model dx/dt = A*x + b*u.
% x0        Initial state of the plant.
% La        Analog regulator feedback gains.
% ftime     Simulate from 0 to ftime seconds.
%
% OUTPUTS: 
%
% x         Matrix of state vectors, column 1 is x0.
% u         Matrix of inputs to the plant.
% t1        Time axis vector for plotting.  Use AREGP to plot results.

%           R.J. Vaccaro 10/93,11/98
%___________________________________________________________________________


clp_=sort(eig(A-b*La));
T_d_=-1/max(real(clp_))/10;
T_d1_=T_d_;
test_=1;
while test_ & (T_d_ > T_d1_/10)
  [phi_d_,gamma_d_]=zohe(A,b,T_d_);
  L_d_=fbg(phi_d_,gamma_d_,exp(T_d_*clp_));
  if abs(norm(clp_-sort(eig(A-b*L_d_))))>.05*norm(clp_)
    T_d_=T_d_/2;
  else
    test_=0;
  end
end
kf_=ceil(ftime/T_d_);
clear x u;
x(:,1)=x0;
u(:,1)=-L_d_*x0;
for k_=1:kf_-1,
x(:,k_+1)=phi_d_*x(:,k_)+gamma_d_*u(:,k_);
  u(:,k_+1)=-L_d_*x(:,k_+1);
end
t1=T_d_*[0:kf_-1];
fprintf('AREG simulation finished.  Use AREGP to plot results.\n');
clear clp_ test_ kf_ phi_d_ gamma_d_ T_d_ L_d_ T_d1_ k_

%___________________________ END OF AREG.M _______________________________


