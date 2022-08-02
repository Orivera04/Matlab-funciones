
function A = postGiv(A, J, i, j)

% Postmultiplication of A by the Givens rotation
% which is represented by the 2-by-2 plannar rotation
% J. Integers i and j describe position of the
% Givens parameters.

A(:,[i j]) = A(:,[i j])*J;


