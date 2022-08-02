

function c = Gaussprod(m, k, b)

% Product c = M*b, where M is the Gauss transformation
% determined by the Gauss vector m and its column
% index k.

n = length(b);
if ( k < 0 | k > n-1 )
   error('Index k is out of range')
end
b = b(:);
c = [b(1:k);-b(k)*m(k+1:n)+b(k+1:n)];
