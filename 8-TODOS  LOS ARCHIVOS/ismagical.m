function m = ismagical(A)
% ISMAGICAL  Check various magic aspects of square matrices.
% m = ismagical(A) is a logical vector with four elements indicating:
% m(1) = Semimagic: all column sums and all row sums are equal.
% m(2) = Magic:  semimagic and both principal diagonals have the same sum.
% m(3) = Panmagic: magic and all the broken diagonals have the same sum.
% m(4) = Associative: all pairs of elements on oppositve sides of the
%        center have the same sum, which must be twice the center value.

[n,n] = size(A);
mu = (n^3 + n)/2;

semimagic = all(sum(A) == mu) && all(sum(A') == mu);

B = fliplr(A);
magic = semimagic && sum(diag(A)) == mu && sum(diag(B)) == mu;

panmagic = magic;
for d = 1:n
   panmagic = panmagic && ...
              sum([diag(A,d); diag(A,d-n)]) == mu && ...
              sum([diag(B,d); diag(B,d-n)]) == mu;
end

B = flipud(B);
associative = all(all(A+B == n^2+1));

m = [semimagic magic panmagic associative];

