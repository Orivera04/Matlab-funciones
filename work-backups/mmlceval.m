function y=mmlceval(x,c,fun)
%MMLCEVAL Evaluate a Linear Combination of Functions. (MM)
% MMLCEVAL(x,C,FUN) evaluates the linear combination of functions
% defined by the string FUN at the values in x. That is, MMLCEVAL
% returns the y where
%
%      y = C(1)*FUN1(x) + C(2)*FUN2(x) ... + C(n)*FUNn(x)
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
% See also MMLCFIT.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 5/17/96, revised 8/16/96, v5: 1/14/97, 6/10/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[rx,cx]=size(x);
x=x(:);
lx=length(x);
c=c(:)';
lc=length(c);
y=zeros(size(x));

if iscellstr(fun) % cell array of strings
   fun=char(fun);
   if lc~=size(fun,1),error('Length of C Not Equal to Rows of FUN.'), end
   for i=1:lc  % evaluate linear combination
      y=y + c(i)*eval(fun(i,:));
   end	
elseif ischar(fun) & size(fun,1)==1 & ~any(abs(fun)<48)  % fun is an M-file
   V=zeros(lx,lc);
   V=feval(fun,x);
   y=sum(V.*repmat(c,lx,1),2);
elseif ischar(fun) & size(fun,1)>1                  % fun is a string matrix
   if lc~=size(fun,1),error('Length of C Not Equal to Rows of FUN.'), end
   for i=1:lc  % evaluate linear combination
      y=y + c(i)*eval(fun(i,:));
   end
else
   error('FUN Does NOT Have the Correct Form.')
end
y=reshape(y,rx,cx);
