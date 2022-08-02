function yval = cubval ( xdata, ydata, ypp, xval )

nval = length ( xval );
l = bracket ( xdata, xval );

for i = 1 : nval

  left = l(i);
  dt = xval(i) - xdata(left);
  h = xdata(left+1) - xdata(left);

  yval(i) = ydata(left)...
    + dt * ( ...
             ( ydata(left+1) - ydata(left) ) / h ...
           - ( ypp(left+1) / 6.0 + ypp(left) / 3.0 ) * h ...
    + dt * ( 0.5 * ypp(left)...
    + dt * ( ( ypp(left+1) - ypp(left) ) / ( 6.0 * h ) ) ) );

end
