function R = gaussm(A,tol)
%GAUSSM	Shows "movie" of  Gaussian elimination.
%       The command R=GAUSSM(A) produces the 
%       reduced row echelon form of A, using pivoting 
%       only when necessary. It is a modified gauss to 
%       make it into a movie. GAUSSM(A,tol) uses the 
%       given tolerance in the rank tests. Hit the space 
%       bar to move to the next step.

%	Copyright 1993 Terry Lawson
%	Terry Lawson, Math Department, Tulane University, 11/93

       
clc
[m,n] = size(A);   

O=eye(m)
A = A
pause

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
     clc, home
     disp(['zero column ' int2str(j)])
      A(i:m,j) = zeros(m-i+1,1)  
      pause
   % increment counter cf of free variables and assign j-th column
      cf = cf + 1;
      fcol(cf) = j;
      j = j + 1;
   else
    
      if i ~= k
         % Swap i-th and k-th rows.
         clc,home
       disp(['Op(' int2str(i) ',' int2str(k) ')'])
       disp([blanks(10)]) 
         O([i k],:) = O([k i],:)
         A([i k],j:n) = A([k i],j:n)
         pause
      end
      % Divide the pivot row by the pivot element.
      %home
      % disp(['pivot = A(' int2str(i) ',' int2str(j) ')'])
     
      % Subtract multiples of the pivot row from lower rows.
      for k = [i+1:m]
         if A(k,j) ~= 0
         clc,home
      
       disp(['O(' int2str(k) ',' int2str(i) ',' num2str(-A(k,j)/A(i,j)) ')'])
       disp([blanks(10)])  
         O(k,:) = O(k,:) - O(i,:)*A(k,j)/A(i,j)
         A(k,j:n) = A(k,j:n) - A(k,j)*A(i,j:n)/A(i,j)  
         
         pause
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
      clc,home
      disp(['end,forw elim '])
      disp(['basic variables'])
      bcol = bcol(1:cb)  
      if cb == n 
      fcol = [];
      else
     disp(['free variables'])
      fcol = fcol(1:n-cb)
      end  
      pause 
      U = A
      O1 = O 
     pause
 % backward elimination step
   for k = cb:-1:1 
    if A(k,bcol(k)) ~= 1
    clc,home
    disp(['Om(' int2str(k) ',' num2str(1/A(k,bcol(k))) ')'])
    disp([blanks(10)]) 
    O(k,:) = O(k,:)/A(k,bcol(k))
    A(k,:) = A(k,:)/A(k,bcol(k))
    pause
    end
    if k ~= 1  
     for p = k-1:-1:1 
     if A(p,bcol(k)) ~= 0 
     clc,home
     disp(['O(' int2str(p) ',' int2str(k) ',' num2str(-A(p,bcol(k))) ')'])
     disp([blanks(10)])         
     O(p,:) = O(p,:) - O(k,:)*A(p,bcol(k))
     A(p,:) = A(p,:)-A(k,:)*A(p,bcol(k))
    pause
     end
    end
  end
 end
  disp(['end back elim'])
  O = O
  R = A
% end of gaussm.  --TL, 9/2/87







