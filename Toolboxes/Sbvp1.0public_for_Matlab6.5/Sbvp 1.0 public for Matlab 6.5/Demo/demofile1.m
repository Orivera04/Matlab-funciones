function out=demofile1(flag,t,y,ya,yb)
%  DEMOFILE1  demonstrates the usage of SBVP
%
%  We try to solve the linear BVP 
%    y'=y , y(0)+y(2)=1+exp(2)
%
%  Solution syntax:
%    [tau,y] = sbvp(@demofile1);     % determine mesh such that the (default) tolerances are satisfied
%    plot(tau,y,'.-');               % plot solution

switch flag
case 'f'       % right-hand side of the differential equation
   out=y;
case 'df/dy'   % Jacobian of f
   out=1;
case 'R'       % boundary condition
   out=ya+yb-(1+exp(2));
case 'dR/dya'  % Jacobian of the boundary condition w.r.t. ya
   out=1;
case 'dR/dyb'  % Jacobian of the boundary conditions w.r.t. yb
   out=1;
case 'tau'     % initial mesh (= beginning and end of the integration interval)
   out=[0 2];
otherwise
   error('unknown flag');
end
