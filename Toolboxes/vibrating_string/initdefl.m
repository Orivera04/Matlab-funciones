function y = initdefl(x)
%
% y = initdefl(x)
%
% This function defines the linearly interpolated initial deflection
% configuration.
%
% x - a vector of points at which the initial deflection is to be computed
% 
% y - transverse initial deflection value for argument x
%
%
% xdat, ydat - global data vectors used for linear interpolation
%
% User m functions required: lintrp
%-------------------------------------------------------------

global xdat ydat
xd = xdat;
yd = ydat;
y = lintrp(xd,yd,x);
%y = interp1(xd,yd,x,'cubic')
