function out=demofile6(flag,t,y,ya,yb)
%  DEMOFILE6  demonstrates the usage of SBVP
%
%  We try to solve a 2-dimensional linear singular BVP 
%  at a very high accuracy level (small RelTol and AbsTol).
%
%  The approximation of the solution after each mesh adaptation 
%  step is displayed by the output function SBVPLOT.
%  Try SBVPPHAS2 as well.
%
%  Solution syntax:
%    [tau,y] = sbvp(@demofile6);    


% some parameters

mu=1;
p1=0.2;
p2=0.05;
k=(p1/p2)^2;     % k=16
alpha=p1/(p2^2); % alpha=80
c=((alpha/k)^k)*exp(k);

mu2 = mu^2;
alpha2 = alpha^2;

switch flag
case 'f'       % right-hand side of the diff. eq. (inhomogeneity only, vectorized)
   out=[zeros(1,length(t)) ; c*t.^(k-1).*exp(-alpha*t).*(k^2-mu2-alpha*t*(1+2*k))];
case 'df/dy'   % Jacobian of f (vectorized differently than in DEMOFILE5)
   out=zeros(2,length(t)); % allocate memory
   for i=1:length(t)
      out(:,[2*i-1 2*i]) = 1/t(i) * [0 1; mu2+alpha2*t(i)^2 0];
   end  
case 'R'       % boundary conditions (negative inhomogeneity only)
   out=-[0; c*exp(-alpha)];
case 'dR/dya'  % Jacobian of the boundary conditions w.r.t. ya
   out=[0 1; 0 0];
case 'dR/dyb'  % Jacobian of the boundary conditions w.r.t. yb
   out=[0 0; 1 0];
case 'tau'     % mesh
   out=[0 1];
case 'bvpopt'  % solution options
   out=sbvpset('RelTol',1e-9,'AbsTol',1e-9,'JacVectorized',1,'fVectorized',1,...
               'IntMaxMinRatio',20,'OutputFcn',@sbvpplot);
otherwise
   error('unknown flag');
end
