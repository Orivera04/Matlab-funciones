% P3_25.M Determine rank of A and A'
%
%
A=input('Input the matrix A ');
A              % Display A
At=A'          %  and A transpose
rankA=rank(A)  % Compute ranks
rankAt=rank(At)
%
%  Are the ranks always the same?- try rand command to generate
%   arbitrary input matrices
%