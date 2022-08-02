function out=demofile5(flag,t,y,ya,yb)
%  DEMOFILE5 demonstrates the usage of SBVP
%
%  We try to solve the 2-dimensional nonlinear BVP 
%    x' = y
%    y' =-sin(x),
%
%  x(0)     = 1
%  y(0)+y(2)= 0
%
%  using vectorized f- and f'-evaluation.
%  We check the user-supplied Jacobians using the 
%  'CheckJac' option, and we display information
%  about the zerofinding process using the 'Display'
%  option. Furthermore we define tolerances for
%  the zerofinder and an upper limit to the number
%  of function evaluations (discretization residual
%  function F(x)). Note that we also provide an
%  initial approximation of the solution.
%
%  Solution syntax:
%    [tau,y] = sbvp(@demofile5);    % determine mesh such that the (default) tolerances are satisfied

switch flag
case 'f'       % right-hand side of the differential equation (vectorized)
   out=[y(2,:) ; -sin(y(1,:))];
case 'df/dy'   % Jacobian of f (vectorized)
   out=zeros(2,2,length(t)); % allocate memory
   for i=1:length(t)
      out(:,:,i)=[0 1; -cos(y(1,i)) 0];  % out(:,:,i) = df/dy(ti,yi)
   end   
case 'R'       % boundary conditions
   out=[ya(1)-1 ; ya(2) + yb(2)];
case 'dR/dya'  % Jacobian of the boundary conditions w.r.t. ya
   out=[1 0;0 1];
case 'dR/dyb'  % Jacobian of the boundary conditions w.r.t. yb
   out=[0 0;0 1];
case 'tau'     % mesh
   out=[0 2];
case 'y0'      % initial approximation
   out=ones(2,length(t));
case 'bvpopt'  % solution options
   my_zfopt = optimset('Display','iter','TolX',1e-13,'MaxFunEvals',10); 
   out = sbvpset('fVectorized',1,'JacVectorized',1,'CheckJac',1,'ZfOpt',my_zfopt);
otherwise
   error('unknown flag');
end
