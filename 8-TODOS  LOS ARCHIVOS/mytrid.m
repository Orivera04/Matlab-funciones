

function B = mytrid(a,b,c,n)

% Function mytrid creates the n-by-n sparse tridiagonal matrix B
% whose all entries along the subdiagonal, main diagonal, 
% and the superdiagonal are equal to a, b, and c, respectively.

e = ones(n,1);
B = spdiags([a*e b*e c*e],-1:1,n,n);
   