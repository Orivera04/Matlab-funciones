function A = rrefquik(A,tol)       %last updated 5/4/95
%RREFQUIK  This function is equivalent to RREF, except it has been
%       made into a "movie" to show the progress of the calculation.
%       rrefquik(A) produces the reduced row echelon form of A.
%
%  By: David R. Hill, Mathematics Dept., Temple Univ.
%      Philadelphia, PA. 19122    Email: hill@math.temple.edu

%Modification of MATLAB's rrefmovie from ver. 3.5
%I wanted something slower for students.  D.R.Hill

[m,n] = size(A);

% Does it appear that elements of A are ratios of small integers?
[num,den] = rat(A);
rats = all(all(A==num./den));

% Compute the default tolerance if none was provided.
if (nargin < 2), tol = max([m,n])*eps*norm(A,'inf'); end

% Loop over the entire matrix.
clc
i = 1;
j = 1;
k = 0;
while (i <= m) & (j <= n)
   % Find value and index of largest element in the remainder of column j.
   [p,k] = max(abs(A(i:m,j))); k = k+i-1;
   if (p <= tol)
      % The column is negligible, zero it out.
      home, disp(['column ' int2str(j) ' is negligible'])
      A(i:m,j) = zeros(m-i+1,1)
      j = j + 1;
   else
      if i ~= k
         % Swap i-th and k-th rows.
         home, disp(['swap rows ' int2str(i) ' and ' int2str(k) blanks(10)])
         A([i k],j:n) = A([k i],j:n)
      end
      % Divide the pivot row by the pivot element.
      home, disp(['pivot = A(' int2str(i) ',' int2str(j) ')' blanks(10)])
      A(i,j:n) = A(i,j:n)/A(i,j)
      % Subtract multiples of the pivot row from all the other rows.
      for k = [1:i-1 i+1:m]
         home, disp(['eliminate in column ' int2str(j) blanks(10)])
         A(k,j:n) = A(k,j:n) - A(k,j)*A(i,j:n)
         eig(rand(25)); %timer statement
      end
      i = i + 1;
      j = j + 1;
      eig(rand(25)); eig(rand(25));%timer statement
   end
end

% Return "rational" numbers if appropriate.
if rats
	[num,den] = rat(A);
	A=num./den;
	clc; A
end

% end of rref.  --CBM, 11/24/85
