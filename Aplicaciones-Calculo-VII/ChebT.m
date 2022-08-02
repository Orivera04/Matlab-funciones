
function T = ChebT(n)

% Coefficients T of the nth Chebyshev polynomial of the first kind.
% They are stored in the descending order of powers.

t0 = 1;
t1 = [1 0];
if n == 0
   T = t0;
elseif n == 1;
   T = t1;
else
   for k=2:n
      T = [2*t1 0] - [0 0 t0];
      t0 = t1;
      t1 = T;
   end
end
