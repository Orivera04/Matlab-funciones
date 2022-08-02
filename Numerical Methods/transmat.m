
function V = transmat(T, S)

% Transition matrix V from a vector space having the ordered
% basis T to another vector space having the ordered basis S. 
% Bases of the vector spaces are stored in columns of the 
% matrices T and S.

[m, n] = size(T);
[p, q] = size(S);
   if (m ~= p) | (n ~= q)
         error('Matrices must be of the same dimension')
   end
V = rref([S T]);
V = V(:,(m + 1):(m + n));
      
      