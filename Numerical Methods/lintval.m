function pval = lintval ( xdata, ydata, xval )
% 
%  LINTVAL evaluates the piecewise linear interpolant to data at a point.
%
  ilo = bracket ( xdata, xval );

  pval = ( ( xdata(ilo+1) - xval ) .* ydata(ilo) ...
         + ( xval - xdata(ilo) ) .* ydata(ilo+1) ...
         ) ./ ( xdata(ilo+1) - xdata(ilo) );


