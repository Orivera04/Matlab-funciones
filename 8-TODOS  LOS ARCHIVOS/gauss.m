function [U,O1,R,O,bcol,fcol] = gauss(A,tol)
%GAUSS	Does Gaussian elimination on A.
%       It find matrices U,O1,R,O with O1 A = U the 
%       matrix at the end of the forward elimination 
%       step of the Gaussian elimination algorithm, and 
%       OA = R the matrix at the end of the backward 
%       elimination step. The tolerance tol can be given
%       or left for the algorithm to determine, and 
%       entries < tol are made 0.The basic variables are 
%       given by bcol and the free variables are given 
%       by fcol. Note that there is no pivoting in this 
%       algorithm.The command is 
%       [U,O1,R,O,bcol,fcol]=GAUSS(A,tol). 

%	Copyright 1993 Terry Lawson
%	Terry Lawson, Math Department, Tulane University, 11/93

[m,n] = size(A);  

O=eye(m);

% Compute the default tolerance if none was provided.
if (nargin < 2), tol = max([m,n])*eps*norm(A,'inf'); end

% Loop over the entire matrix.
i = 1;
j = 1;          
bcol = zeros(1,n);
fcol = zeros(1,n);
cb = 0;
cf = 0;
while (i <= m) & (j <= n)
k = i;

while (abs(A(k,j)) < tol) & (k < m) 
% Find nonzero value in column j below row i if there is one
    k = k + 1;
 end
   if (k == m) & (abs(A(m,j)) < tol)
      % The column is negligible, zero it out.
      A(i:m,j) = zeros(m-i+1,1)  ;
   % increment counter cf of free variables and assign j-th column
      cf = cf + 1;
      fcol(cf) = j;
      j = j + 1;
   else
    
      if i ~= k
         % Swap i-th and k-th rows.
         A([i k],j:n) = A([k i],j:n);
         O([i k],:) = O([k i],:);
      end
      % Divide the pivot row by the pivot element.
      % Subtract multiples of the pivot row from lower rows.
      for k = [i+1:m]
         if A(k,j) ~= 0
         O(k,:) = O(k,:) - O(i,:)*A(k,j)/A(i,j);
         A(k,j:n) = A(k,j:n) - A(k,j)*A(i,j:n)/A(i,j);
        end
      end          
     % increment counter cb of basic variables and assign j-th column
      cb = cb + 1;
      bcol(cb) = j;
      i = i + 1;
      j = j + 1;
   end
end   
   if i==m+1 & j<=n
     while j <= n
      cf = cf+1;
      fcol(cf) = j;
     j = j+1;
    end
  end
      bcol = bcol(1:cb);  
      if cb == n
      fcol = [];
      else
      fcol = fcol(1:n-cb);
      end  
    U = A;
    O1 = O;
 % backward elimination step
   for k = cb:-1:1 
    if A(k,bcol(k)) ~= 1
    O(k,:) = O(k,:)/A(k,bcol(k));
    A(k,:) = A(k,:)/A(k,bcol(k)) ;
    end
    if k ~= 1  
     for p = k-1:-1:1 
     if A(p,bcol(k)) ~= 0 
     O(p,:) = O(p,:) - O(k,:)*A(p,bcol(k));
     A(p,:) = A(p,:)-A(k,:)*A(p,bcol(k));
     end
    end
  end
 end
  R = A;








