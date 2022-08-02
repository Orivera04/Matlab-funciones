function jac=vdpoljac(t,y,mu)
%VDPOLJAC van der Pol equation Jacobian.

% mu = ?; now passed as an input argument

if nargin<3 % supply default if not given
   mu=2;
end
jac = [       0                    1
       (-2*mu*y(1)*y(2)-1) (mu*(1-y(1)^2))];
