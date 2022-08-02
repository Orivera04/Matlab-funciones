function out = banana(x, y, mode)
%BANANA Rosenbrock's banana function. 
%	The minimum point is [1.1], at which f(x,y)=0.

if nargin <= 2, mode = 0; end

if mode == 0,		% return function value
	out= 100.*(y-x.^2).^2+(1-x).^2;
elseif mode == 1,	% return gradient
	fx = -400.*(y-x.^2).*x-2+2.*x;
	fy = 200.*y-200.*x.^2; 
	out = [fx; fy];
elseif mode == 2,	% return Hessian
	fxx=1200.*x.^2-400.*y+2;
	fxy=-400.*x;
	fyy=200;
	out = [fxx fxy; fxy fyy];
else
	error('Wrong mode value!');
end
