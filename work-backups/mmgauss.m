function q=mmgauss(fun,xlims,n,varargin)
%MMGAUSS Numerically Evaluate Cumulative Integral. (MM)
% Q=MMGAUSS(FUN,Xlims,N) approximates the integral of FUN(X)
% using an N point Gauss quadrature rule, which is exact
% for a polynomial up to degree 2*N-1. The integration limits
% are given by Xlims=[LowerLimit UpperLimit].
%
% FUN can be a character string expression, an inline function,
% an M-file function, or a function handle.
% FUN is not evaluated at either limit, but is evaluated at their
% mean if N is odd. FUN(X) must return an array the same size as X.
%
% If Xlims contains more than two elements, the integral is computed
% over each interval Xlims(i) to Xlims(i+1) using the N point rule.
% The result Q is an array the same size as Xlims whose i-th element
% is the cumulative integral from Xlims(1) to Xlims(i).
% Q(end) is the composite integral from Xlims(1) to Xlims(end).
%
% MMGAUSS(FUN,Xlims,N,P1,P2,...) passes extra arguments to FUN, i.e.
% FUN is called as FUN(X,P1,P2,...) where X is the variable of
% integration.
%
% See also QUAD, QUADL, MMQUAD, MMINTGRL, MMSPAREA

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 2/5/00, 2/24/01
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<3
   error('At Least Three Input Arguments Required.')
end
if ischar(fun) & ~isvarname(fun)
   [fun,msg]=fcnchk(fun,length(varargin),'vectorized');
   error(msg)
end

if length(n)~=1 | round(n)~=n | n<1 | n>64
   error('N Must be a Positive Scalar Integer.')
else
   [bp,w]=local_getgauss(n);
end
xsiz=size(xlims);
xlims=xlims(:);
dx=diff(xlims)/2;       % (xlims(i+1)-xlims(i))/2
sx=dx+xlims(1:end-1);   % (xlims(i+1)+xlims(i))/2
xlen=length(xlims);
if xlen==2  % single integration interval
   x=bp*dx+sx;    % transform [-1,1] to Xlims range
   W=w*dx;        % transform weights as well
   fx=feval(fun,x,varargin{:});
   q=fx(:)'*W;
else        % cumulative integral desired
   q=zeros(1,xlen);
   for i=2:xlen % loop rather than use large arrays
      ii=i-1;
      x=bp*dx(ii)+sx(ii);
      W=w*dx(ii);
      fx=feval(fun,x,varargin{:});
      q(i)=fx(:)'*W;
   end
   q=reshape(cumsum(q),xsiz);
end
%-------------------------------------------------------------------
function [bp,w]=local_getgauss(n)
% Return Base Points bp and Weights w for an n point
% Gauss quadrature rule for the interval [-1,1];
% Based on M-files by Howard Wilson and Peter J. Acklam.
% Alogrithm for base points and weights can be found in
% P. Davis and P. Rabinowitz, "Methods of Numerical Integration"

u=1:n-1;
u=u./sqrt(4*u.^2-1);
[v,bp]=eig(diag(u,-1)+diag(u,1));
[bp,k]=sort(diag(bp));
w=2*v(1,k)'.^2;