function out=demofile2(flag,t,y,ya,yb,lambda)
%  DEMOFILE2  demonstrates the usage of SBVP
%
%  We try to solve the linear BVP 
%    y'=lambda * y , y(0)+y(2)=4
%  using a parameter lambda, that is passed as last argument.
%
%  Solution syntax:
%    my_lambda = 3;
%    [tau,y] = sbvp(@demofile2,'','','',my_lambda);  
%                          % determine mesh such that tolerances are satisfied
%                          % starting with the initial mesh defined in DEMOFILE2

switch flag
case 'f'       % right-hand side of the differential equation 
   out=lambda * y;
case 'df/dy'   % Jacobian of f
   out=lambda;
case 'R'       % boundary condition
   out=ya+yb-4;
case 'dR/dya'  % Jacobian of the boundary condition w.r.t. ya
   out=1;
case 'dR/dyb'  % Jacobian of the boundary condition w.r.t. yb
   out=1;
case 'tau'     % (initial) mesh
   out=linspace(0,2,51);
otherwise
   error('unknown flag');
end
