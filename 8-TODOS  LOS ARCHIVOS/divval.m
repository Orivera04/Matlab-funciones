function pval = divval ( xval, xdata, d )

n = size ( d, 2 );

pval = d(n);

for i = n - 1 : -1: 1
  pval = d(i) + ( xval - xdata(i) ) * pval;
end

