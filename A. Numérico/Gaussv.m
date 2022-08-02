
function m = Gaussv(x, k)

% Gauss vector m from the vector x and the position 
% k (k > 0)of the pivot entry.

if x(k) == 0
   error('Wrong vector')
end;
n = length(x);
x = x(:);
if ( k > 0 & k < n )
   m = [zeros(k,1);x(k+1:n)/x(k)];
else
   error('Index k is out of range')
end


   

