function pval = paraval ( xdata, ydata, xval )
% 
%  PARAVAL evaluates the piecewise parabolic interpolant to data at a point.
%
%  1:  Determine the double interval containing XVAL.
%
ilo = bracket ( xdata, xval );
%
%  If the value is even, move it down by 1.
%
ilo = 1 + 2 * floor ( ( ilo - 1 ) / 2 );
%
%  2:  Determine the parabolic approximation in the interval.
%
c = ydata(ilo);

b = ( ydata(ilo+1) - ydata(ilo) ) ./ ( xdata(ilo+1) - xdata(ilo) );

a = ( (ydata(ilo+2)-ydata(ilo+1)) ./ ( xdata(ilo+2) - xdata(ilo+1) )...
    - (ydata(ilo+1)-ydata(ilo)) ./ ( xdata(ilo+1) - xdata(ilo) )...
    ) ./ ( xdata(ilo+2) - xdata(ilo) );
%
%  3: Evaluate the polynomial at XVAL.
%
  pval = ( a   .* ( xval - xdata(ilo+1) ) ...
         + b ) .* ( xval - xdata(ilo) ) ...
         + c ;

