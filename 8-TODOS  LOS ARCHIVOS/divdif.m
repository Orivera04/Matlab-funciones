function d = divdif ( xdata, ydata )

n = size ( xdata, 2 );
d = ydata;

for i = 1 : n - 1
  for j = n : -1 : i + 1
    d(j) = ( d(j) - d(j-1) ) / ( xdata(j) - xdata(j-i) );
  end
end

