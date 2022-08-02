function y = BEAMODE( t, y, flag, var),
% Equations of a stiff beam
% see Hairer, Wanner II, pp 8-10
%
% Parameters:
%   t      (input)  : time
%   y      (input)  : actual positions and velocities
%   flag   (-)      : not used
%   var    (-)      : not used
%   y      (output) : actual value of the right hand side

% Authors: Stefan Hüeber
% Date   : November 6, 2002
% Version: 1.0

% Number of Discretiziation of the beam
S = length(y)/2;

help = ones(S,1);
GINV = spdiags([-help,2*help,-help],[-1,0,1],S,S);
GINV(1,1) = 3;
GINV(S,S) = 1;
clear help;

F = FUNC(t);
v = S^4 * (-GINV*y(1:S,1)) ...
		+ S^2 * (F(2)*cos(y(1:S,1)) - F(1)*sin(y(1:S,1)));

GINV(1,1) = 1;
GINV(S,S) = 3;

clear i;
MAT = diag(exp(i*y(1:S,1))) * GINV * diag(exp(-i*y(1:S,1)));
clear GINV;
C = real(MAT);
CINV = inv(C);
D = imag(MAT);
clear MAT;

help = y(S+1:2*S,1).^2;
w = D*v + help;
u = CINV*w;

y(1:S,1) = y(S+1:2*S,1);
y(S+1:2*S,1) = C*v + D*u;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function F = FUNC(t)

tmp = 1.5*(sin(t))^2*(t<=pi);
%tmp = 1.0*(t<=1);

F(1) = -tmp;
F(2) = tmp;
