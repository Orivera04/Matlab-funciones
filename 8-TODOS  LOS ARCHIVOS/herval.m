function pval = herval ( xdata, ydata, ypdata, xval )
% 
%  HERVAL evaluates the Hermite interpolant to data at a point.
%
%  Which interval does XVAL lie in?
%
  ilo = bracket ( xdata, xval );
%
%  Determine the polynomial coefficients in that interval.
%
%  This is not the best way to do it.  I'd like to set up a vector
%  of coefficients and call POLYVAL, but I really want to be able to
%  call this routine with a vector of arguments, and this just keeps
%  the headache level lower.
%
  d = ydata(ilo);

  c = ypdata(ilo);

  b = 3 * ( ydata(ilo+1) - ydata(ilo) ) ./ ( xdata(ilo+1) - xdata(ilo) ).^2 ...
    - ( 2 * ypdata(ilo) + ypdata(ilo+1) ) ./ ( xdata(ilo+1) - xdata(ilo) );

  a = ( ypdata(ilo) + ypdata(ilo+1) ) ./ ( xdata(ilo+1) - xdata(ilo) ) .^2 ...
    - 2 * ( ydata(ilo+1) - ydata(ilo) ) ./ ( xdata(ilo+1) - xdata(ilo) ).^3;
%
%  Evaluate the polynomial at XVAL.
%
  pval = ( ( a   .* ( xval - xdata(ilo) ) ...
           + b ) .* ( xval - xdata(ilo) ) ...
           + c ) .* ( xval - xdata(ilo) ) ...
           + d;
