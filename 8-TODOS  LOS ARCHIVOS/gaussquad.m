function anss = gaussquad(f,a,b,tol,varargin)
% GAUSSQUAD(f,a,b,tol) Definite integration using Gauss-Legendre 
% quadrature.  Finds the definite integral of function f from a to b. 
% User can define the relative convergence tolerence, tol; the default is 
% 10^-14.  If f is an inline function, it need not accept vector args.
% Function f can also be ananymous or a func. handle.
%
% Example:       >>f=inline('sin(x)/x+exp(-x)');
%                >>gaussquad(f,-1,1)
%                ans =
%                     4.24256852802197
% After first changing f to accept vector args:
% Compare to:    >>quad(f,-1,1,10^-14)
% Author:  Matt Fig
% Date:  revised 1/31/2006
% Contact:  popkenai@yahoo.com

f=fcnchk(f,'vectorized');           % Allows use of non-vectorized inlines.
% Check for infinite boundaries.
         
if isinf(f(a)) | isinf(f(b))
    anss = Inf;  
    warning('Infinite value at one or more endpoints.')
   return
end

if nargin < 4,  tol = 1e-14;  end                               % Defaults.

% Initially use a 40 point Gauss-Legendre quadrature in 15 subintervals.
gp = 40;  cnt = 1;  ints = 15;  maxcount = 35;   
anss1 = 1;  anss2 = 0;                          % Initialization for while.

% Main loop.  Each pass through, the number of intervals and Gauss points 
% is increased until either the tol is met or the maxcount is exceeded.                                                                                                                                                     
while abs(anss2-anss1) >= tol & cnt < maxcount
      anss1 = core(f,a,b,gp,ints);
      anss2 = core(f,a,b,gp+8,ints+3);
      gp =  gp+16;
      ints = ints+6;
      cnt = cnt+1;
end 

% Give a warning if max iterations is reached and give an error estimate.
if cnt>=maxcount                 
    str = sprintf(['Maximum iterations reached, results may be\n'...
                   '         inaccurate.  Estimated error: %.2d'],...
                   abs(anss2-anss1));
    warning(str)
end

anss = anss2;


function anss= core(f,a,b,gp,ints)
% Core subfunction that performs the integrations.
[abs1, wgt1] = Gauss(gp);                               % Get Gauss points.
bb(1) = a;                                              % Get subintervals.
bb(2:ints) = [2:ints]*(b-a)/ints+a;
dif = diff(bb)/2;
% Evaluate f at scaled intervals, need to map each interval to [-1 1].
an = f((abs1+1)*dif+repmat(bb(1:end-1),gp,1));      % Function evaluations.
new = dif*an'*wgt1;                % Multiply by the weights and intervals.
anss = sum(new(:));


function [x, w] = Gauss(n)
% Generates the abscissa and weights for a Gauss-Legendre quadrature.
% Reference:  Numerical Recipes in Fortran 77, Cornell press.
x = zeros(n,1);                                           % Preallocations.
w = x;
m = (n+1)/2;
for ii=1:m
    z = cos(pi*(ii-.25)/(n+.5));                        % Initial estimate.
    z1 = z+1;
while abs(z-z1)>eps
    p1 = 1;
    p2 = 0;
    for jj = 1:n
        p3 = p2;
        p2 = p1;
        p1 = ((2*jj-1)*z*p2-(jj-1)*p3)/jj;       % The Legendre polynomial.
    end
    pp = n*(z*p1-p2)/(z^2-1);                        % The L.P. derivative.
    z1 = z;
    z = z1-p1/pp;
end
    x(ii) = -z;                                   % Build up the abscissas.
    x(n+1-ii) = z;
    w(ii) = 2/((1-z^2)*(pp^2));                     % Build up the weights.
    w(n+1-ii) = w(ii);
end