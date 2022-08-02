function [xsol, ysol] = newton2d(varargin)
%NEWTON2D 2-dimensional Newton's method
% The command
% [xsol, ysol] = newton2d(eq1, eq2, xstart, ystart)
% searches for a root of the simultaneous (nonlinear) 
% equations eq1=0 and eq2=0, starting from the initial 
% guesses x=xstart, y=ystart.  Here eq1 and eq2 should be
% entered as strings in the variables 'x' and 'y' or 
% as symbolic expressions in x and y. Alternatively,
% [xsol, ysol] = newton2d(eq1, eq2, xvar, yvar, xstart, ystart)
% allows one to specify the names of the independent variables.
% The optional argument 'maxiterations' at the end specifies the
% maximum number of iterations to try. The default is 20.
%
% Example: [xsol, ysol] = newton2d('x^2 + y^2 - 4', 'x - y', 1, 1) 
% gives the output 
% xsol =
%
%    1.4142
% 
%
% ysol =
%
%    1.4142
%
%
% written by Jonathan Rosenberg, 8/10/99
% revised 8/22/05

if nargin<4
    error('not enough input arguments -- need at least the two equations and starting values for x and y'); 
end

if nargin>7, error('too many input arguments'); end

eq1=varargin{1}; eq2=varargin{2};
if ischar(eq1) & ~ischar(eq2)
    error('both equations must be of same form: strings or symbolic')
end
if ~ischar(eq1) & ischar(eq2)
    error('both equations must be of same form: strings or symbolic')
end
% Default value of maxiterations is 20.
maxiterations=20;
% Default values of xvar and yvar are 'x', 'y'.
if nargin<6
    xvar = 'x'; yvar = 'y'; xstart = varargin{3}; ystart = varargin{4}; 
end
if nargin>5
    xvar = varargin{3}; yvar = varargin{4}; 
    xstart = varargin{5}; ystart = varargin{6}; 
end
if nargin==5, maxiterations=varargin{5}; end
if nargin==7, maxiterations=varargin{7}; end

% Start by computing partial derivatives.
f11 = diff(sym(eq1), xvar);
f12 = diff(sym(eq1), yvar);
f21 = diff(sym(eq2), xvar);
f22 = diff(sym(eq2), yvar);
% Vector functions for evaluation
F1  = inline(vectorize(eq1),xvar,yvar);  
F2  = inline(vectorize(eq2),xvar,yvar);
A11 = inline(vectorize(f11),xvar,yvar);
A12 = inline(vectorize(f21),xvar,yvar);
A21 = inline(vectorize(f12),xvar,yvar);
A22 = inline(vectorize(f22),xvar,yvar);
X  = [xstart, ystart];
for counter=1:maxiterations
A  = [A11(X(1), X(2)), A12(X(1), X(2)); A21(X(1), X(2)), A22(X(1), X(2))]; 
F = [F1(X(1), X(2)), F2(X(1), X(2))];
    if max(abs(F)) < eps, xsol=X(1);
% process has converged
    ysol=X(2); return; end
    if condest(A) > 10^10, error('matrix of partial derivatives singular or almost singular -- try again with different starting values'); end
    X  = X - F/A;
end
xsol=X(1); ysol=X(2);
