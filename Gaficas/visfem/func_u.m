function u= func_u(x)
% Call: u= fun_u(x);
% Input:
%    x ... Nx2; Vector of vertices
% Globals:
%    bsp ... Controls examples (see switch below)
% Output:
%    u ... Nx1; Vector of function values at vertices
% Description:
%    x |--> u(x)

% Author: W. Doerfler, Univ. Karlsruhe.
% Last modified:
% 03.03.2002, W. Doerfler. Matlab 6.1.0450.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Global definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global bsp;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch bsp
case 1 % Quadratic harmonic
   u= x(:,1).*x(:,1)-x(:,2).*x(:,2);
case 2 % Fourth order polynomial with zero bc on [0,1]^2
   u= 2*( x(:,1).*(1-x(:,1)).*x(:,2).*(1-x(:,2)) );
case 3 % Sombrero
   r= x(:,1).*x(:,1)+x(:,2).*x(:,2);% r is in fact r^2 !
   u= 2*(0.25-r).*(0.85-r);
otherwise
   disp('*** Error *** No such example');
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%