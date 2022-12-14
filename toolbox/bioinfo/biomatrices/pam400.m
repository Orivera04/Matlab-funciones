function [matrix, matrixInfo] = pam400
%PAM400 substitution matrix in 1/5 bit units,
%   Expected score = -0.521, Entropy = 0.139 bits
%   Lowest score = -8, Highest score = 26
%
%   Order:
%   A  R  N  D  C  Q  E  G  H  I  L  K  M  F  P  S  T  W  Y  V  B  Z  X  *
%
%   [MATRIX,MATRIXINFO] = PAM400 returns a structure of information about
%   the matrix with fields Name, Scale, Entropy, ExpectedScore, LowestScore,
%   HighestScore and Order.

% Source:  ftp://ftp.ncbi.nih.gov/blast/matrices/
%   $Revision: 1.5 $ 

matrix = [...
   1 -1  0  1 -2  0  1  1 -1  0 -2 -1 -1 -3  1  1  1 -6 -3  0  1  0  0 -8;...
  -1  5  1  0 -4  1  0 -2  2 -2 -3  4  0 -4  0  0  0  3 -4 -2  0  1  0 -8;...
   0  1  1  2 -3  1  2  1  1 -1 -3  1 -1 -3  0  1  0 -4 -3 -1  2  1  0 -8;...
   1  0  2  3 -5  2  3  1  1 -2 -3  1 -2 -5  0  1  0 -7 -4 -2  2  2  0 -8;...
  -2 -4 -3 -5 17 -5 -5 -3 -3 -2 -6 -5 -5 -4 -2  0 -2 -8  1 -2 -4 -5 -3 -8;...
   0  1  1  2 -5  3  2  0  3 -2 -2  1 -1 -4  0  0  0 -5 -4 -1  2  2  0 -8;...
   1  0  2  3 -5  2  3  1  1 -2 -3  1 -2 -5  0  0  0 -7 -4 -1  2  3  0 -8;...
   1 -2  1  1 -3  0  1  4 -1 -2 -3 -1 -2 -5  0  1  1 -7 -5 -1  1  0  0 -8;...
  -1  2  1  1 -3  3  1 -1  5 -2 -2  1 -1 -2  0  0 -1 -2  0 -2  1  2  0 -8;...
   0 -2 -1 -2 -2 -2 -2 -2 -2  4  3 -2  2  2 -1 -1  0 -5  0  3 -2 -2  0 -8;...
  -2 -3 -3 -3 -6 -2 -3 -3 -2  3  7 -2  4  3 -2 -2 -1 -2  0  3 -3 -2 -1 -8;...
  -1  4  1  1 -5  1  1 -1  1 -2 -2  4  0 -5  0  0  0 -3 -4 -2  1  1  0 -8;...
  -1  0 -1 -2 -5 -1 -2 -2 -1  2  4  0  5  1 -1 -1  0 -4 -1  2 -2 -1  0 -8;...
  -3 -4 -3 -5 -4 -4 -5 -5 -2  2  3 -5  1 11 -4 -3 -3  2 10  0 -4 -5 -2 -8;...
   1  0  0  0 -2  0  0  0  0 -1 -2  0 -1 -4  5  1  1 -6 -5 -1  0  0  0 -8;...
   1  0  1  1  0  0  0  1  0 -1 -2  0 -1 -3  1  1  1 -3 -3 -1  1  0  0 -8;...
   1  0  0  0 -2  0  0  1 -1  0 -1  0  0 -3  1  1  1 -5 -3  0  0  0  0 -8;...
  -6  3 -4 -7 -8 -5 -7 -7 -2 -5 -2 -3 -4  2 -6 -3 -5 26  1 -6 -5 -6 -4 -8;...
  -3 -4 -3 -4  1 -4 -4 -5  0  0  0 -4 -1 10 -5 -3 -3  1 13 -2 -3 -4 -2 -8;...
   0 -2 -1 -2 -2 -1 -1 -1 -2  3  3 -2  2  0 -1 -1  0 -6 -2  4 -1 -1  0 -8;...
   1  0  2  2 -4  2  2  1  1 -2 -3  1 -2 -4  0  1  0 -5 -3 -1  2  2  0 -8;...
   0  1  1  2 -5  2  3  0  2 -2 -2  1 -1 -5  0  0  0 -6 -4 -1  2  3  0 -8;...
   0  0  0  0 -3  0  0  0  0  0 -1  0  0 -2  0  0  0 -4 -2  0  0  0 -1 -8;...
  -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8  1;...
    ];

if nargout >1
    matrixInfo.Name = 'PAM400';
    matrixInfo.Scale = 1/5;
    matrixInfo.Entropy = 0.139 ;
    matrixInfo.ExpectedScore = -0.521;
    matrixInfo.LowestScore = -8;
    matrixInfo.HighestScore = 26;
    matrixInfo.Order = 'ARNDCQEGHILKMFPSTWYVBZX*';
end

