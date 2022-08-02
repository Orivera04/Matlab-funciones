function out = peaksf(x, y, mode)
% Peaks function for illustrating steepest descent, Newton,
% and LM directions.
% All the derivatives were found by using Symbolic Math Toolbox.

% J.-S. Roger Jang, June 12, 1996

if nargin <= 2, mode = 0; end

if mode == 0,		% return function value
	out = 3*(1-x).^2.*exp(-(x.^2) - (y+1).^2) ... 
	      - 10*(x/5 - x.^3 - y.^5).*exp(-x.^2-y.^2) ... 
	      - 1/3*exp(-(x+1).^2 - y.^2); 
elseif mode == 1,	% return gradient
	fx=-6*(1-x)*exp(-x^2-(y+1)^2)-6*(1-x)^2*x*exp(-x^2-(y+1)^2)-10*(1/5-3*x^2)*exp(-x^2-y^2)+20*(1/5*x-x^3-y^5)*x*exp(-x^2-y^2)-1/3*(-2*x-2)*exp(-(x+1)^2-y^2);
	fy=3*(1-x)^2*(-2*y-2)*exp(-x^2-(y+1)^2)+50*y^4*exp(-x^2-y^2)+20*(1/5*x-x^3-y^5)*y*exp(-x^2-y^2)+2/3*y*exp(-(x+1)^2-y^2);
	out = [fx; fy];
elseif mode == 2,	% return Hessian
	fxx=36*x*exp(-x^2-(y+1)^2)-18*x^2*exp(-x^2-(y+1)^2)-24*x^3*exp(-x^2-(y+1)^2)+12*x^4*exp(-x^2-(y+1)^2)+72*x*exp(-x^2-y^2)-148*x^3*exp(-x^2-y^2)-20*y^5*exp(-x^2-y^2)+40*x^5*exp(-x^2-y^2)+40*x^2*exp(-x^2-y^2)*y^5-2/3*exp(-(x+1)^2-y^2)-4/3*exp(-(x+1)^2-y^2)*x^2-8/3*exp(-(x+1)^2-y^2)*x;
	fxy=-6*(1-x)*(-2*y-2)*exp(-x^2-(y+1)^2)-6*(1-x)^2*x*(-2*y-2)*exp(-x^2-(y+1)^2)+20*(1/5-3*x^2)*y*exp(-x^2-y^2)-100*y^4*x*exp(-x^2-y^2)-40*(1/5*x-x^3-y^5)*x*y*exp(-x^2-y^2)+2/3*(-2*x-2)*y*exp(-(x+1)^2-y^2);
	fyy=-6*(1-x)^2*exp(-x^2-(y+1)^2)+3*(1-x)^2*(-2*y-2)^2*exp(-x^2-(y+1)^2)+200*y^3*exp(-x^2-y^2)-200*y^5*exp(-x^2-y^2)+20*(1/5*x-x^3-y^5)*exp(-x^2-y^2)-40*(1/5*x-x^3-y^5)*y^2*exp(-x^2-y^2)+2/3*exp(-(x+1)^2-y^2)-4/3*y^2*exp(-(x+1)^2-y^2);
	out=[fxx fxy; fxy fyy];
else
	error('Wrong mode value!');
end

% The following are commands for symbolic toolbox
%f='3*(1-x)^2*exp(-(x^2)-(y+1)^2)-10*(x/5-x^3-y^5)*exp(-x^2-y^2)-1/3*exp(-(x+1)^2-y^2)';
%fx=simple(diff(f, 'x'))
%fy=simple(diff(f, 'y'))
%fxx=simple(diff(fx, 'x'))
%fxy=simple(diff(fx, 'y'))
%fyy=simple(diff(fy, 'y'))
