function pval = lagval ( xdata, ydata, xval )

n = size ( xdata, 2 );

pval = 0;
for i = 1 : n
  pval = pval + ydata(i) .* lag_poly ( xdata, i, xval );
end



