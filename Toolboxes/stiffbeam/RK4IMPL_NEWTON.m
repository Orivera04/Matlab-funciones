function [y,l] = RK4IMPL_BEAM(t, y, h, varargin)
% RK4IMPL Runge-Kutta-Algorithm
%    Executes one step of stepwidth h of the implicit 
%    Runge-Kutta-Algorithm of Hammer and Hollingsqorth to 
%    solve a system of differential equations of first order 
%    defined in 'ode'. RK2IMPL requires the
%    same function format as Matlabs ODE... solvers.
%    the algortihm is of order4
%    y  : values of next time step
%    n  : number of inner itaerations
% RK4IMPL(ode, t, y, h, p1, p2, ...)
%    ode: Ordinary differential equation (Matlab format)
%    t  : Time variable
%    y  : values of preceding time step
%    h  : stepwidth
%    p1, ... pn : Funktion arguments passed to the ode file
%
% Butcher-Scheme of the implemented Runge-Kutta-Method:
%   1/2 - \sqrt(3)/6  |      1/4          1/4 - \sqrt(3)/6 
%   1/2 + \sqrt(3)/6  | 1/4 + \sqrt(3)/6        1/4
%  --------------------------------------------------------
%                     |      1/2                1/2
%

% Newton Method for computing k_1 and k_2 for the
% Equations of a stiff beam (see Hairer, Wanner II, pp 8-10)

% Parameters:
%   t      (input)  : time
%   y      (input)  : actual positions and velocities
%   flag   (-)      : not used
%   var    (-)      : not used
%   y      (output) : actual value of the right hand side
%   l      (output) : number of netwon iterations

% Author : Stefan Hüeber
% Date   : November 20, 2002
% Version: 1.0

tol = 10e-6;
MAXSTEP = 500;

% Coefficients for the RK4IMPL-Method
alpha =[ 0.5 - sqrt(3)/6; 0.5 + sqrt(3)/6 ];
beta = [ 0.25,   0.25 - sqrt(3)/6; 0.25 + sqrt(3)/6,  0.25];

% Number of Discretiziation of the beam
S = length(y)/2;

% Compute the gradient of the function 
help = ones(S,1);
GINV = spdiags([-help,2*help,-help],[-1,0,1],S,S);
clear help;
GINV(S,S) = 3;

GDISC = -GINV;
GDISC(1,1) = -3;
GDISC(S,S) = -1;

F = FUNC(t);
v = S^4 * (GDISC*y(1:S,1)) ...
		+ S^2 * (F(2)*cos(y(1:S,1)) - F(1)*sin(y(1:S,1)));
GRADv = S^4*GDISC + S^2*diag(-F(2)*sin(y(1:S,1)) - F(1)*cos(y(1:S,1)));

clear i;
MAT = diag(exp(i*y(1:S,1))) * GINV * diag(exp(-i*y(1:S,1)));
clear GINV;
C = real(MAT);
CINV = inv(C);
D = imag(MAT);

DMATv = spdiags([i*diag(MAT,-1).*(v(2:S)-v(1:S-1)), zeros(S-1,1),...
								i*diag(MAT,1).*(v(1:S-1)-v(2:S)); 0 0 0],[-1,0,1],S,S);
GRADCv = real(DMATv);
GRADDv = imag(DMATv);

w = D*v + y(S+1:2*S,1).^2;
GRADw = GRADDv + D*GRADv;
u = CINV*w;

DMATu = spdiags([i*diag(MAT,-1).*(u(2:S)-u(1:S-1)), zeros(S-1,1),...
								i*diag(MAT,1).*(u(1:S-1)-u(2:S)); 0 0 0],[-1,0,1],S,S);
GRADCu = real(DMATu);
GRADDu = imag(DMATu); 
GRADu = CINV*(GRADw - GRADCu);
GRAD2 = GRADCv + C*GRADv + GRADDu + D*GRADu;
JACOBIAN = [zeros(S,S), eye(S); GRAD2, 2*D*CINV*diag(y(S+1:2*S,1))];

JACINV = inv([eye(2*S)-h*beta(1,1)*JACOBIAN, -h*beta(1,2)*JACOBIAN;...
							-h*beta(2,1)*JACOBIAN, eye(2*S)-h*beta(2,2)*JACOBIAN]);

% Initialization of k_i
knew = zeros(4*S,1);
kold = ones(4*S,1);

% Newton Iterations
l = 0;
while ((norm(knew-kold) > tol) & (l < MAXSTEP))
	kold = knew;
	knew = kold - JACINV*(kold -...
												[BEAMODE(t+h*alpha(1),...
																 y+h*(beta(1,1)* kold(1:2*S,1) +...
																			beta(1,2)*kold(2*S+1:4*S)));...
										BEAMODE(t+h*alpha(2),...
														y+h*(beta(2,1)* kold(1:2*S,1) +... 
																 beta(2,2)*kold(2*S+1:4*S)))]);
	
	l = l+1;
end

y = y + h * 0.5 * (knew(1:2*S,1) + knew(2*S+1:4*S,1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function F = FUNC(t)

tmp = 1.5*(sin(t))^2*(t<=pi);
F(1) = -tmp;
F(2) = tmp;
