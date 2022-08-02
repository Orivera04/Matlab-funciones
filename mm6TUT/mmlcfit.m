function c=mmlcfit(x,y,w,fun)
%MMLCFIT Curve Fit to a Linear Combination of Functions. (MM)
% MMLCFIT(x,y,FUN) fits the data vector pairs x and y to the
% functions defined by the string FUN. That is, MMLCFIT returns
% the row vector c where
%
%      y = C(1)*FUN1(x) + C(2)*FUN2(x) ... + C(n)*FUNn(x)
%
% is minimized in the least squares sense.
%
% FUN is either an M-file returning a matrix having length(x) rows
% and n columns, where n is the number of functions, with the (i)th column
% of the output being FUNi(x),
%
% or FUN a string matrix where EVAL(FUN(i,:)) is FUNi(x), e.g.,
% FUN=['sin(x)';'exp(x)';'log(x)'], where FUN1(x)=sin(x).
%
% or FUN is a cell array of strings where EVAL(FUN{i}) is FUNi(x), e.g.,
% FUN={'sin(x)','exp(x)','log(x)'}, where FUN1(x)=sin(x).
%
% x is passed to each function FUNi(x) as a column vector.
% A column vector result is expected.
%
% MMLCFIT(x,y,w,'FUN') uses weighted fitting where w is a vector whose
% (i)th element is the relative weight associated with x(i) and y(i).
%
% See also MMLCEVAL, MMRWLS.

% Calls: mmrwls

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 5/17/96, revised 8/16/96, v5: 1/14/97, 6/10/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

x=x(:);
lx=length(x);
y=y(:);
ly=length(y);
if nargin==3,fun=w; w=ones(size(x)); end
if ly~=lx,error('x and y Must Have the Same Length.'), end

if iscellstr(fun) % cell array of strings
   fun=char(fun);
   lc=size(fun,1);
   V=zeros(lx,lc);  % create matrix
   for i=1:lc
      V(:,i)=eval(fun(i,:));
   end
elseif ischar(fun) & size(fun,1)==1 & ~any(abs(fun)<48)  % fun is an M-file
   V=feval(fun,x);
elseif ischar(fun) & size(fun,1)>1                  % fun is a string matrix
   lc=size(fun,1);
   V=zeros(lx,lc);  % create matrix
   for i=1:lc
      V(:,i)=eval(fun(i,:));
   end
else
   error('FUN Does NOT Have the Correct Form.')
end
c=mmrwls(y,V,w).';
