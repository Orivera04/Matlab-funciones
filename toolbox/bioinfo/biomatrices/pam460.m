function [matrix, matrixInfo] = pam460
%PAM460 substitution matrix in 1/6 bit units,
%   Expected score = -0.429, Entropy = 0.0994 bits
%   Lowest score = -9, Highest score = 30
%
%   Order:
%   A  R  N  D  C  Q  E  G  H  I  L  K  M  F  P  S  T  W  Y  V  B  Z  X  *
%
%   [MATRIX,MATRIXINFO] = PAM460 returns a structure of information about
%   the matrix with fields Name, Scale, Entropy, ExpectedScore, LowestScore,
%   HighestScore and Order.

% Source:  ftp://ftp.ncbi.nih.gov/blast/matrices/
%   $Revision: 1.5 $ 

matrix = [...
   1 -1  0  1 -2  0  1  1  0  0 -1  0 -1 -3  1  1  1 -6 -3  0  1  0  0 -9;...
  -1  5  1  0 -4  1  0 -1  2 -2 -2  4  0 -4  0  0  0  4 -4 -2  0  1  0 -9;...
   0  1  1  2 -3  1  1  1  1 -1 -2  1 -1 -3  0  1  0 -4 -3 -1  1  1  0 -9;...
   1  0  2  3 -5  2  3  1  1 -2 -3  1 -2 -5  0  1  0 -7 -4 -1  2  2  0 -9;...
  -2 -4 -3 -5 19 -5 -5 -3 -3 -2 -6 -5 -5 -3 -2  0 -2 -9  2 -2 -4 -5 -2 -9;...
   0  1  1  2 -5  2  2  0  2 -1 -2  1 -1 -4  1  0  0 -5 -4 -1  1  2  0 -9;...
   1  0  1  3 -5  2  3  1  1 -2 -3  1 -2 -5  0  1  0 -7 -4 -1  2  2  0 -9;...
   1 -1  1  1 -3  0  1  4 -1 -2 -3 -1 -2 -5  1  1  1 -7 -5 -1  1  0  0 -9;...
   0  2  1  1 -3  2  1 -1  5 -2 -2  1 -1 -2  0  0  0 -2  0 -2  1  2  0 -9;...
   0 -2 -1 -2 -2 -1 -2 -2 -2  3  3 -2  2  2 -1 -1  0 -5  0  3 -2 -2  0 -9;...
  -1 -2 -2 -3 -6 -2 -3 -3 -2  3  7 -2  4  3 -2 -2 -1 -1  1  3 -3 -2 -1 -9;...
   0  4  1  1 -5  1  1 -1  1 -2 -2  4  0 -5  0  0  0 -3 -4 -2  1  1  0 -9;...
  -1  0 -1 -2 -5 -1 -2 -2 -1  2  4  0  4  1 -1 -1  0 -4 -1  2 -2 -1  0 -9;...
  -3 -4 -3 -5 -3 -4 -5 -5 -2  2  3 -5  1 12 -4 -3 -3  2 11  0 -4 -5 -2 -9;...
   1  0  0  0 -2  1  0  1  0 -1 -2  0 -1 -4  4  1  1 -6 -5 -1  0  0  0 -9;...
   1  0  1  1  0  0  1  1  0 -1 -2  0 -1 -3  1  1  1 -3 -3 -1  1  0  0 -9;...
   1  0  0  0 -2  0  0  1  0  0 -1  0  0 -3  1  1  1 -5 -3  0  0  0  0 -9;...
  -6  4 -4 -7 -9 -5 -7 -7 -2 -5 -1 -3 -4  2 -6 -3 -5 30  2 -6 -6 -6 -4 -9;...
  -3 -4 -3 -4  2 -4 -4 -5  0  0  1 -4 -1 11 -5 -3 -3  2 14 -2 -4 -4 -2 -9;...
   0 -2 -1 -1 -2 -1 -1 -1 -2  3  3 -2  2  0 -1 -1  0 -6 -2  3 -1 -1  0 -9;...
   1  0  1  2 -4  1  2  1  1 -2 -3  1 -2 -4  0  1  0 -6 -4 -1  2  2  0 -9;...
   0  1  1  2 -5  2  2  0  2 -2 -2  1 -1 -5  0  0  0 -6 -4 -1  2  2  0 -9;...
   0  0  0  0 -2  0  0  0  0  0 -1  0  0 -2  0  0  0 -4 -2  0  0  0  0 -9;...
  -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9  1;...
    ];

if nargout >1
    matrixInfo.Name = 'PAM460';
    matrixInfo.Scale = 1/6;
    matrixInfo.Entropy = 0.0994 ;
    matrixInfo.ExpectedScore = -0.429;
    matrixInfo.LowestScore = -9;
    matrixInfo.HighestScore = 30;
    matrixInfo.Order = 'ARNDCQEGHILKMFPSTWYVBZX*';
end

