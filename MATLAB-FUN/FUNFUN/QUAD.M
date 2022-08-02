function [Q,cnt] = quad(funfcn,a,b,tol,trace,p1,p2,p3,p4,p5,p6,p7,p8,p9)
%QUAD	Numerical evaluation of an integral, low order method.
%	Q = QUAD('F',A,B) approximates the integral of F(X) from A to B
%	to within a relative error of 1e-3.  'F' is a string
%	containing the name of the function.  Function F must return a
%	vector of output values if given a vector of input values.
%	Q = QUAD(F,A,B,TOL) integrates to a relative error of TOL.
%	Q = Inf is returned if an excessive recursion level is reached,
%	indicating a possibly singular integral.
%	Q = QUAD(F,A,B,TOL,TRACE) integrates to a relative error of TOL and
%	traces the function evaluations with a point plot of the integrand.
%
%	QUAD uses an adaptive recursive Simpson's rule.
%
%	Q = QUAD('F',A,B,TOL,TRACE,P1,P2,...) allows coefficients P1, P2, ...
%	to be passed directly to function F:   G = F(X,P1,P2,...).
%	To use default values for TOL or TRACE, you may pass in the empty matrix ([]).
%	See also QUAD8.

%	C.B. Moler, 3-22-87.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% [Q,cnt] = quad(F,a,b,tol) also returns a function evaluation count.

if nargin < 4, tol = 1.e-3; trace = 0; end
if nargin < 5, trace = 0; end
c = (a + b)/2;
if isempty(tol), tol = 1.e-3; end
if isempty(trace), trace = 0; end

% Top level initialization
x = [a b c a:(b-a)/10:b];
% set up function call
args = '(x';
args1 = [];
for n = 1:nargin-5
   args1 = [args1,',p',int2str(n)];
end
args1 = [args1,')'];
args = [args args1];
y = eval([funfcn,args]);
fa = y(1);
fb = y(2);
fc = y(3);
if trace
    lims = [min(x) max(x) min(y) max(y)];
    if any(imag(y))
        lims(3) = min(min(real(y)),min(imag(y)));
        lims(4) = max(max(real(y)),max(imag(y)));
    end
    ind = find(~finite(lims));
    if ~isempty(ind)
        [mind,nind] = size(ind);
        lims(ind) = 1.e30*(-ones(mind,nind) .^ rem(ind,2));
    end
    axis(lims);
    plot([c b],[fc fb],'.')
    hold on
    if any(imag(y))
        plot([c b],imag([fc fb]),'+')
    end
end
lev = 1;

% Adaptive, recursive Simpson's quadrature
if any(imag(y))
    Q0 = 1e30;
else
    Q0 = inf;
end
[Q,cnt] = eval(['quadstp(funfcn,a,b,tol,lev,fa,fc,fb,Q0,trace',args1]);
cnt = cnt + 3;
if trace
    hold off
    axis('auto');
end
