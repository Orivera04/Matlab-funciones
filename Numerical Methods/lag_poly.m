function pval = lag_poly ( xdata, i, xval )

n = size ( xdata, 2 );

pval = 1;
for j = 1 : n
  if ( j ~= i ) 
    pval = pval .* ( xval - xdata(j) ) ./ ( xdata(i) - xdata(j) );
  end
end


