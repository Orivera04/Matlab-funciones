function xint=arclenf(x)
% CALL: xint=arclenf(x) defines the integrand for a parabolic function
%  this is sqrt(1+(df/dx)**2)   df/dx = CINT*x
%     CINT is a global constant from calling program
%
global CINT
xint=sqrt(1 + CINT*x.^2);
%
