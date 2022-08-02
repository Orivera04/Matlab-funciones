function out=demofile3(flag,t,y,ya,yb)
%  DEMOFILE3  demonstrates the usage of SBVP
%
%  We try to solve the linear BVP 
%    y'=y , y(0)+y(2)=1+exp(2)
%
%  using a Runge-Kutta basis of degree 6 on Gaussian
%  collocation points. Note the BVPOPT-case.
%
%  Solution syntax:
%    [tau,y] = sbvp(@demofile3);     % determine mesh such that the (default) tolerances are satisfied

switch flag
case 'f'       % right-hand side of the differential equation
   out=y;
case 'df/dy'   % Jacobian of f
   out=1;
case 'R'       % boundary condition
   out=ya+yb-(1+exp(2));
case 'dR/dya'  % Jacobian of the boundary condition w.r.t. ya
   out=1;
case 'dR/dyb'  % Jacobian of the boundary condition w.r.t. yb
   out=1;
case 'tau'     % mesh
   out=[0 2];
case 'bvpopt'  % solution options
   out=sbvpset('ColPts','Gauss','Basis','RungeKutta','DegreeSelect','Manual','Degree',6);
otherwise
   error('unknown flag');
end
