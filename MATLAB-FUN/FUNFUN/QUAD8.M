function [Q,cnt] = quad8(funfcn,a,b,tol,trace,p1,p2,p3,p4,p5,p6,p7,p8,p9)
%QUAD8	Numerical evaluation of an integral, higher order method.
%	Q = QUAD8('F',A,B) approximates the integral of F(X) from A
%	to B to within a relative error of 1e-3.  'F' is a string
%	containing the name of the function.  The function must return
%	a vector of output values if given a vector of input values.
%	Q = QUAD8(F,A,B,TOL) integrates to a relative error of TOL.
%	Q = Inf is returned if an excessive recursion level is reached,
%	indicating a possibly singular integral.
%	Q = QUAD8(F,A,B,TOL,TRACE) integrates to a relative error of TOL and
%	traces the function evaluations with a point plot of the integrand.
%
%	QUAD8 uses an adaptive recursive Newton Cotes 8 panel rule.
%	Q = QUAD8('F',A,B,TOL,TRACE,P1,P2,...) allows coefficients P1, P2, ...
%	to be passed directly to function F:   G = F(X,P1,P2,...).
%	To use default values for TOL or TRACE, you may pass in the empty matrix ([]).
%	See also QUAD.

%	Cleve Moler, 5-08-88.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% [Q,cnt] = quad8(F,a,b,tol) also returns a function evaluation count.

if nargin < 4, tol = 1.e-3; trace = 0; end
if nargin < 5, trace = 0; end
if isempty(tol), tol = 1.e-3; end
if isempty(trace), trace = 0; end
% QUAD8 usually does better than the default 1e-3.
h = b - a;

% Top level initialization, Newton-Cotes weights
w = [3956 23552 -3712 41984 -18160 41984 -3712 23552 3956]/14175;
x = a + (0:8)*(b-a)/8;
%y = feval(funfcn,x);
% set up function call
args = '(x';
args1 = [];
for n = 1:nargin-5
   args1 = [args1,',p',int2str(n)];
end
args1 = [args1,')'];
args = [args args1];
y = eval([funfcn,args]);
yllow = min([min(real(y)) min(imag(y))]);
ylhi = max([max(real(y)) max(imag(y))]);
lims = [min(x) max(x) yllow ylhi];
ind = find(~finite(lims));
if ~isempty(ind)
    [mind,nind] = size(ind);
    lims(ind) = 1.e30*(-ones(mind,nind) .^ rem(ind,2));
end
if trace
    axis(lims);
% doesn't take care of complex case
    plot([a b],[real(y(1)) real(y(9))],'.'), hold on
    if any(imag(y))
        plot([a b],[imag(y(1)) imag(y(9))],'+')
    end
end
lev = 1;

% Adaptive, recursive Newton-Cotes 8 panel quadrature
if any(imag(y))
    Q0 = 1e30;
else
    Q0 = inf;
end
[Q,cnt] = eval(['quad8stp(funfcn,a,b,tol,lev,w,x,y,Q0,trace',args1]);
cnt = cnt + 9;
if trace
    hold off
    axis('auto');
end
