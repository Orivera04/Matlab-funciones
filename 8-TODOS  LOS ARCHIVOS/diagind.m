function I=diagind(n,k)
% I=diagind(n,k)
% returns linear indices for a square matrix of order n
% k is the kth diagonal. k>0 above of main diag , k<0 under main diag
% and k=0 the main diag

% Masoud Alipour, Dec 2004

if nargin==1
    k=0;
end

if abs(k)>=n
    error 'k should be smaller than n';
end

% these formulas return linear indices of kth diag
if k>=0
    I=k*n+1:n+1:n^2;
else
    k=abs(k);
    I=k+1:n+1:n^2-(k*n);
end