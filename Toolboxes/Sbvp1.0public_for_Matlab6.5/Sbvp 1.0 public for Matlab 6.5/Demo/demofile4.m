function out=demofile4(flag,t,y,ya,yb)
%  DEMOFILE4  demonstrates the usage of SBVP
%
%  We try to solve the 2-dimensional linear BVP 
%    x' = y
%    y' =-x,
%
%  x(0)     = 1
%  y(0)+y(2)= 0
%
%  using vectorized f-evaluation.
%
%  Solution syntax:
%    [tau,y] = sbvp(@demofile4);     % determine mesh such that the (default) tolerances are satisfied

switch flag
case 'f'       
%  out=[y(2) ; y(1)]    would be the nonvectorized version   
   out=[y(2,:) ; -y(1,:)];
case 'df/dy'   % Jacobian of f
   out=[0 1;-1 0];
case 'R'       % boundary conditions
   out=[ya(1)-1 ; ya(2) + yb(2)];
case 'dR/dya'  % Jacobian of the boundary conditions w.r.t. ya
   out=[1 0;0 1];
case 'dR/dyb'  % Jacobian of the boundary conditions w.r.t. yb
   out=[0 0;0 1];
case 'tau'     % mesh
   out=[0 2];
case 'bvpopt'  % solution options
   out=sbvpset('fvectorized',1);
otherwise
   error('unknown flag');
end
