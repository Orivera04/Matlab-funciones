function  P = pcsfit (X, S)

for  k = 1:length(X)-1
   W(k) = X(k):.01:X(k+1);
   Z(k) = polyval(S(k, :), W(k) - X(k));
end

