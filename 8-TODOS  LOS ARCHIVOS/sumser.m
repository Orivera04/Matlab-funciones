function [u,t,x] = sumser(a,b,c,funt,funx, ...
                   tmin,tmax,nt,xmin,xmax,nx)
%
% [u,t,x] = sumser(a,b,c,funt,funx,tmin, ...
%                  tmax,nt,xmin,xmax,nx)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function evaluates a function U(t,x) 
% which is defined by a finite series. The 
% series is evaluated for t and x values taken 
% on a rectangular grid network. The matrix u 
% has elements specified by the following 
% series summation:
%
% u(i,j)  =   sum(    a(k)*funt(t(i)* ...
%           k=1:nsum
%                     b(k))*funx(c(k)*x(j))
%
% where nsum is the length of each of the 
% vectors a, b, and c.
%
% a,b,c        - vectors of coefficients in 
%                the series
% funct,funx   - functions which accept a 
%                matrix argument.  funct is 
%                evaluated for an argument of 
%                the form func(t*b) where t is 
%                a column and b is a row. funx
%                is evaluated for an argument 
%                of the form funx(c*x) where 
%                c is a column and x is a row.
% tmin,tmax,nt - produces vector t with nt 
%                evenly spaced values between 
%                tmin and tmax
% xmin,xmax,nx - produces vector x with nx 
%                evenly spaced values between 
%                xmin and xmax
% u            - the nt by nx matrix 
%                containing values of the 
%                series evaluated at t(i),x(j),
%                for i=1:nt and j=1:nx
% t,x          - column vectors containing t 
%                and x values. These output 
%                values are optional.
%
% User m functions called:  none.
%----------------------------------------------

tt=(tmin:(tmax-tmin)/(nt-1):tmax)';
xx=(xmin:(xmax-xmin)/(nx-1):xmax); a=a(:).';
u=a(ones(nt,1),:).*feval(funt,tt*b(:).')*...
  feval(funx,c(:)*xx);
if nargout>1, t=tt; x=xx'; end