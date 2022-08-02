function anss = rombquad(f,a,b,m)
%ROMBQUAD(f,a,b,m) evaluates the integral of f from a to b.
% f is an inline function or function handle.
% a is the lower limit of integration.
% b is the upper limit of integration.
% m - is the exponent in the relative error.  For example m = 10 implies an
% estimated relative error of 1e(-10).
% Example:  >>f=inline('x^2') % Note inline funcs. need not be vectorized.
%           >>rombquad(f,0,2);
% or if you have created a function m-file, func.m (must be vectorized):
%           >>rombquad(@func,0,2);
f = fcnchk(f,'vectorized');   % Allow use of nonvectorized inline fun. 
if nargin<3
   error ('Error, not enough arguments. See help.')
elseif nargin<4
    m=10;
end

h = 2.^((1:m)-1)*(b-a)/2^(m-1);             % These are the intervals used.
k1 = 2.^[(m-2):-1:-1]*2+1;                      % Index into the intervals.
f1 = feval(f,[a:h(1):b]);                           % Function evaluations.
R = zeros(1,m);                                           % Pre-allocation.
% Define the starting vector:
for ii = 1:m
	R(ii) = 0.5*h(ii)*(f1(1)+2*...
                       sum(f1(k1(end-ii+1):k1(end-ii+1)-1:end-1))+f1(end)); 
end
% Interpolations:
for jj = 2:m
    jpower = (4^(jj-1)-1);
    for kk = 1:(m-jj+1)
        R(kk) = R(kk)+(R(kk)-R(kk+1))/jpower; 
    end 
end
anss = R(1);