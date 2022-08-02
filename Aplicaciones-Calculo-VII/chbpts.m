function x=chbpts(xmin,xmax,n)
%
% x=chbpts(xmin,xmax,n)
% ~~~~~~~~~~~~~~~~~~~~~
% Determine n points with Chebyshev spacing 
% between xmin and xmax.
%
% User m functions called:  none
%----------------------------------------------

x=(xmin+xmax)/2+((xmin-xmax)/2)* ...
  cos(pi/n*((0:n-1)'+.5));