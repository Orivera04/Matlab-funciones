function [x,dx] = autodiff_sparse(x,func,varargin)
% AUTOdiff_SPARSE is a function that can be used to wrap some
% objective function for optimization using derivatives. 
% For example, instead of calling fminunc with objective function FUN as
%  X=FMINUNC(FUN,X0,OPTIONS,P1,P2,...)
% you should call
%  X=FMINUNC('autodiff_sparse',X0,OPTIONS,FUN,P1,P2,...)

if nargout==1
   x = feval(func,x,varargin{:});
else
   [x,dx] = adiffget(feval(func,adiff(x,'sparse'),varargin{:}));
   dx = dx';
end
