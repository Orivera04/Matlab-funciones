function q=mmquad(fun,xlims,tol,varargin)
%MMQUAD Numerically Evaluate Integral. (MM)
% Q=MMQUAD(FUN,Xlims,TOL) approximates the integral of FUN(X)
% given integration limits Xlims=[LowerLimit UpperLimit] and
% relative and absolute error tolerances TOL=[RelTol AbsTol].
%
% FUN can be a character string expression, an inline function,
% an M-file function or a function handle.
% FUN is not evaluated at either limit.
% FUN(X) must return an array the same size as X.
%
% FUN(X) is integrated with a variable order Gauss quadrature rule
% until the difference between approximations meets the tolerance
% specification. If TOL=[] or is not given, TOL=[1e-6 1e-12].
%
% MMQUAD(FUN,Xlims,TOL,P1,P2,...) passes extra arguments to FUN,
% i.e., FUN is called as FUN(X,P1,P2,...) where X is the variable
% of integration.
%
% See also QUAD, QUADL, MMGAUSS, MMINTGRL, MMSPAREA

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 2/22/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<2
   error('At Least Two Input Arguments Required.')
end
if nargin==2
   tol=[1e-6 1e-12];
else
   tol=tol(:)';
   if length(tol)>2
      error('TOL Must Have Two Elements.')
   elseif tol(1)<1e-12 | tol(2)<0
      error('TOL Elements Negative or Too Small.')
   end
end
xlims=xlims(:).';
if length(xlims)~=2
   error('Xlims Must Contain Two Elements.')
end
n=[8 12 16 24 32 48 64]; % gauss point numbers to try
qo=mmgauss(fun,xlims,4,varargin{:});
for i=1:length(n)
   q=mmgauss(fun,xlims,n(i),varargin{:});
   if abs(qo-q)<(tol(1)*abs(q)+tol(2))
      return
   else
      qo=q;
   end
end
% solution hasn't converged
warning('MMQUAD Error Requirements Not Met.')
