function v=trapsum(a,b,y,n)
%
% v=trapsum(a,b,y,n)
% ~~~~~~~~~~~~~~~~~~
%
% This function evaluates:
%
%   integral(a=>x, y(x)*dx) for a<=x<=b
%
% by the trapezoidal rule (which assumes linear
% function variation between succesive function
% values).
%
% a,b - limits of integration
% y   - integrand which can be a vector valued
%       function returning a matrix such that
%       function values vary from row to row.
%       It can also be input as a matrix with
%       the row size being the number of
%       function values and the column size
%       being the number of components in the
%       in the vector function.
% n   - the number of function values used to
%       perform the integration.  When y is a
%       matrix then n is computed as the number
%       of rows in matrix y.
%
% v   - integral value
%
% User m functions called:  none
%----------------------------------------------

if isstr(y)
  % y is an externally defined function
  x=linspace(a,b,n)'; h=x(2)-x(1);
  Y=feval(y,x); % Function values must vary in 
                % row order rather than column 
                % order or computed results 
                % will be wrong.
  m=size(Y,2);
else
  % y is column vector or a matrix
  Y=y; [n,m]=size(Y); h=(b-a)/(n-1);
end
v=[zeros(1,m); ...
  h/2*cumsum(Y(1:n-1,:)+Y(2:n,:))];