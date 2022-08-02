function out = paraf(x, y, mode)
% Parabolic surface for illustrating steepest descent, Newton,
% and LM directions.

% J.-S. Roger Jang, June 9, 1996

if nargin <= 2, mode = 0; end

a=1;b=1;c=1;d=-1;e=1;
if mode == 0,		% return function value
	out=a*x.^2+b*x.*y+c*y.^2+d*x+e*y;
elseif mode == 1,	% return gradient
	out = [2*a*x+b*y+d; b*x+2*c*y+e];
elseif mode == 2,	% return Hessian
	out = [2*a b; b 2*c];
else
	error('Wrong mode value!');
end
