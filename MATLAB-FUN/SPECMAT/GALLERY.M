function A = gallery(n)
%GALLERY A couple of small test matrices.
%	GALLERY(3) is a badly conditioned 3-by-3 matrix.
%	GALLERY(5) is an interesting eigenvalue problem.  Try to find
%	its EXACT eigenvalues and eigenvectors.
%
%	See also MAGIC, HILB, INVHILB, HADAMARD, ROSSER, WILKINSON.

%	C. Moler, 4-30-87.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if n == 3
   A = [ -149   -50  -154
          537   180   546
          -27    -9   -25 ];

elseif n == 5
   A = [  -9     11    -21     63    -252
          70    -69    141   -421    1684
        -575    575  -1149   3451  -13801
        3891  -3891   7782 -23345   93365
        1024  -1024   2048  -6144   24572 ];

else
   A = [];
end
