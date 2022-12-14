function [matrix, matrixInfo] = pam200cdi
%PAM200CDI substitution matrix in 1/10 Bit Units, 
%   Expected score = -4.12, Entropy = 0.507 bits
%   Lowest score = -30, Highest score = 59
%
%   Order:
%   A  R  N  D  C  Q  E  G  H  I  L  K  M  F  P  S  T  W  Y  V  B  Z  X  *
%
%   [MATRIX,MATRIXINFO] = PAM200CDI returns a structure of information about
%   the matrix with fields Name, Scale, Entropy, ExpectedScore, LowestScore,
%   HighestScore and Order.

% Source:  ftp://ftp.ncbi.nih.gov/blast/matrices/
%   $Revision: 1.5 $ 

matrix = [...
    9  -7   0   0  -9  -3   1   4  -7  -3  -8  -6  -5 -14   4   5   5 -23 -14   1   0  -1  -1 -30;...
   -7  24  -1  -7 -15   4  -6 -12   5  -8 -13  12  -2 -18  -1  -2  -5   7 -17 -11  -4  -1  -4 -30;...
    0  -1  10   9 -15   2   5   1   7  -8 -12   4  -8 -14  -3   3   2 -16  -8  -8   9   4  -2 -30;...
    0  -7   9  16 -21   6  14   1   2 -10 -17  -1 -12 -23  -5   0  -2 -27 -17 -10  13  11  -4 -30;...
   -9 -15 -15 -21  41 -22 -22 -14 -14  -9 -25 -22 -22 -18 -12  -1 -10 -30   0  -8 -18 -22 -13 -30;...
   -3   4   2   6 -22  18  10  -6  11  -9  -7   2  -4 -19   0  -3  -4 -20 -17  -8   4  14  -3 -30;...
    1  -6   5  14 -22  10  16   0   1  -9 -14  -1  -9 -22  -4  -1  -3 -28 -17  -8  10  14  -3 -30;...
    4 -12   1   1 -14  -6   0  19 -10 -12 -17  -8 -12 -19  -3   4  -1 -28 -22  -6   1  -3  -4 -30;...
   -7   5   7   2 -14  11   1 -10  26 -11  -9  -2 -10  -8  -2  -4  -6 -11  -1 -10   4   7  -3 -30;...
   -3  -8  -8 -10  -9  -9  -9 -12 -11  19   8  -8   8   3  -9  -6   0 -21  -5  14  -9  -9  -3 -30;...
   -8 -13 -12 -17 -25  -7 -14 -17  -9   8  22 -12  13   5 -11 -12  -8  -8  -5   6 -15 -11  -6 -30;...
   -6  12   4  -1 -22   2  -1  -8  -2  -8 -12  19   2 -22  -6  -1  -1 -15 -18 -11   1   0  -4 -30;...
   -5  -2  -8 -12 -22  -4  -9 -12 -10   8  13   2  28  -1  -9  -7  -3 -18 -12   6 -10  -7  -3 -30;...
  -14 -18 -14 -23 -18 -19 -22 -19  -8   3   5 -22  -1  33 -18 -13 -13  -1  23  -6 -18 -21 -10 -30;...
    4  -1  -3  -5 -12   0  -4  -3  -2  -9 -11  -6  -9 -18  23   3   0 -23 -20  -6  -4  -2  -3 -30;...
    5  -2   3   0  -1  -3  -1   4  -4  -6 -12  -1  -7 -13   3   8   6  -9 -11  -5   2  -2  -1 -30;...
    5  -5   2  -2 -10  -4  -3  -1  -6   0  -8  -1  -3 -13   0   6  12 -21 -11   1   0  -3  -1 -30;...
  -23   7 -16 -27 -30 -20 -28 -28 -11 -21  -8 -15 -18  -1 -23  -9 -21  59  -2 -26 -21 -24 -17 -30;...
  -14 -17  -8 -17   0 -17 -17 -22  -1  -5  -5 -18 -12  23 -20 -11 -11  -2  37 -11 -12 -17 -10 -30;...
    1 -11  -8 -10  -8  -8  -8  -6 -10  14   6 -11   6  -6  -6  -5   1 -26 -11  18  -9  -8  -3 -30;...
    0  -4   9  13 -18   4  10   1   4  -9 -15   1 -10 -18  -4   2   0 -21 -12  -9  12   8  -3 -30;...
   -1  -1   4  11 -22  14  14  -3   7  -9 -11   0  -7 -21  -2  -2  -3 -24 -17  -8   8  14  -3 -30;...
   -1  -4  -2  -4 -13  -3  -3  -4  -3  -3  -6  -4  -3 -10  -3  -1  -1 -17 -10  -3  -3  -3  -4 -30;...
  -30 -30 -30 -30 -30 -30 -30 -30 -30 -30 -30 -30 -30 -30 -30 -30 -30 -30 -30 -30 -30 -30 -30   1;...
    ];

if nargout >1
    matrixInfo.Name = 'PAM200CDI';
    matrixInfo.Scale = 0.1;
    matrixInfo.Entropy = 0.507 ;
    matrixInfo.ExpectedScore = -4.12;
    matrixInfo.LowestScore = -30;
    matrixInfo.HighestScore = 59;
    matrixInfo.Order = 'ARNDCQEGHILKMFPSTWYVBZX*';
end

