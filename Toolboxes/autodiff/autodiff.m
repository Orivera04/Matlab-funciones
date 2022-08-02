function [x,dx] = autodiff(x,func,varargin)
% AUTODIFF is a function that can be used to wrap some
% objective function for optimization using derivatives. 
% For example, instead of calling fminunc with objective function FUN as
%  X=FMINUNC(FUN,X0,OPTIONS,P1,P2,...)
% you should call
%  X=FMINUNC('autodiff',X0,OPTIONS,FUN,P1,P2,...)
%
% The jacobian is transposed here compared to the usual ado object, because
% fminunc and similar expect column vectors of derivatives.

if nargout==1
   x = feval(func,x,varargin{:});
else
   [x,dx] = adiffget(feval(func,adiff(x),varargin{:}));
   dx = dx';
end
