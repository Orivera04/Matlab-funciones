function Q = dblquadx(intfcn,f_xmin,f_xmax,ymin,ymax,tol,quadf,varargin) 
%   DBLQUAD Numerically evaluate double integral. 
%   DBLQUAD(FUN,XMIN,XMAX,YMIN,YMAX) evaluates the double integral of
%   FUN(X,Y) over the F_XMIN <= X <= F_XMAX, YMIN <= Y <= YMAX.
%   F_XMIN and F_XMAX accept both numerical and function handle values
%   to perform integration over irregular region.
%   i.e Q=\int^{ymax}_{ymin}dy \int^{f_xmax(y)}_{f_xmin(y)} dx f(x,y), 
%   where f_xmax(y) and f_xmin(y) are user-defined functions
%   upper and lower boundaries respectively.
%   FUN(X,Y) should accept a vector X and a scalar Y and return a
%   vector of values of the integrand.
%
%   DBLQUAD(FUN,XMIN,XMAX,YMIN,YMAX,TOL) uses a tolerance TOL
%   instead of the default, which is 1.e-6.
%
%   DBLQUAD(FUN,XMIN,XMAX,YMIN,YMAX,TOL,@QUADL) uses quadrature
%   function QUADL instead of the default QUAD.  
%   DBLQUAD(FUN,XMIN,XMAX,YMIN,YMAX,TOL,@MYQUADF) uses your own
%   quadrature function MYQUADF instead of QUAD.  MYQUADF should
%   have the same calling sequence as QUAD and QUADL.
%
%   DBLQUAD(FUN,XMIN,XMAX,YMIN,YMAX,TOL,@QUADL,P1,P2,...) passes
%   the extra parameters to FUN(X,Y,P1,P2,...).
%   DBLQUAD(FUN,XMIN,XMAX,YMIN,YMAX,[],[],P1,P2,...) is the same
%   as DBLQUAD(FUN,XMIN,XMAX,YMIN,YMAX,1.e-6,@QUAD,P1,P2,...)
%
%   Example:
%       FUN can be an inline object or a function handle.
%
%         Q = dblquad(inline('y*sin(x)+x*cos(y)'), pi, 2*pi, 0, pi) 
%
%       or
%
%         Q = dblquad(@integrnd, pi, 2*pi, 0, pi) 
%
%       where integrnd.m is an M-file:       
%           function z = integrnd(x, y)
%           z = y*sin(x)+x*cos(y);  
%
%       This integrates y*sin(x)+x*cos(y) over the square
%       pi <= x <= 2*pi, 0 <= y <= pi.  Note that the integrand 
%       can be evaluated with a vector x and a scalar y .
%
%       Nonsquare regions can be handled by setting the integrand
%       to zero outside of the region.  The volume of a hemisphere is
%
%         dblquad(inline('sqrt(max(1-(x.^2+y.^2),0))'),-1,1,-1,1)
%
%       or
%
%         dblquad(inline('sqrt(1-(x.^2+y.^2)).*(x.^2+y.^2<=1)'),-1,1,-1,1)
%
%   See also QUAD, QUADL, TRIPLEQUAD, INLINE, @.

%   Copyright 1984-2002 The MathWorks, Inc.
%   $Revision: 1.15 $  $Date: 2002/04/08 20:26:44 $

if nargin < 5, error('Requires at least five inputs'); end
if nargin < 6 | isempty(tol), tol = 1.e-6; end 
if nargin < 7 | isempty(quadf), quadf=@quadx; end
intfcn = fcnchk(intfcn);

trace = [];
Q = feval(quadf, @innerintegral, ymin, ymax, tol, trace, intfcn, ...
           f_xmin, f_xmax, tol, quadf); 
%---------------------------------------------------------------------------

function Q = innerintegral(y, intfcn, f_xmin, f_xmax, tol, quadf, varargin) 
%INNERINTEGRAL Used with DBLQUAD to evaluate inner integral.
%
%   Q = INNERINTEGRAL(Y,INTFCN,F_XMIN,F_XMAX,TOL,QUADF)
%   Y is the value(s) of the outer variable at which evaluation is
%   desired, passed directly by QUAD. INTFCN is the name of the
%   integrand function, passed indirectly from DBLQUAD. F_XMIN and F_XMAX
%   are the integration limits for the inner variable, passed indirectly
%   from DBLQUAD. TOL is passed to QUAD (QUADL) when evaluating the inner 
%   loop, passed indirectly from DBLQUAD. The function handle QUADF
%   determines what quadrature function is used, such as QUAD, QUADL
%   or some user-defined function.

% Evaluate the inner integral at each value of the outer variable. 
Q = zeros(size(y));  trace = [];
for i = 1:length(y) 
    if isnumeric(f_xmin)
        xmin=f_xmin;
    else
        xmin=feval(f_xmin,y(i));
    end
    if isnumeric(f_xmax)
        xmax=f_xmax;
    else
        xmax=feval(f_xmax,y(i));
    end
    %if isobject(intfcn)
    %    Q(i) = feval(quadf, intfcn, xmin, xmax, tol, trace, y(i)); 
    %else
        Q(i) = feval(quadf, intfcn, xmin, xmax, tol, trace, y(i), varargin{:}); 
        %end
end 
