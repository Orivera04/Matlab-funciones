function [matrix, matrixInfo] = pam160cdi
%PAM160CDI substitution matrix in 1/10 Bit Units, 
%   Expected score = -5.73, Entropy = 0.694 bits
%   Lowest score = -35, Highest score = 60
%
%   Order:
%   A  R  N  D  C  Q  E  G  H  I  L  K  M  F  P  S  T  W  Y  V  B  Z  X  *
%
%   [MATRIX,MATRIXINFO] = PAM160CDI returns a structure of information about
%   the matrix with fields Name, Scale, Entropy, ExpectedScore, LowestScore,
%   HighestScore and Order.

% Source:  ftp://ftp.ncbi.nih.gov/blast/matrices/
%   $Revision: 1.5 $ 

matrix = [...
   12 -10  -1  -1 -11  -4   0   4  -9  -4 -10  -8  -7 -17   4   5   6 -27 -17   0  -1  -1  -2 -35;...
  -10  28  -3 -11 -17   4  -9 -15   5 -10 -16  13  -3 -21  -3  -3  -7   6 -21 -14  -7  -2  -6 -35;...
   -1  -3  14  10 -18   1   5   0   8  -9 -15   4 -11 -17  -5   4   2 -19  -9 -11  12   3  -2 -35;...
   -1 -11  10  20 -26   5  16   0   1 -13 -21  -2 -15 -28  -8  -1  -3 -32 -21 -13  16  12  -5 -35;...
  -11 -17 -18 -26  43 -27 -27 -17 -16 -11 -30 -27 -26 -23 -15  -1 -12 -35  -2 -10 -22 -27 -16 -35;...
   -4   4   1   5 -27  23  11  -9  12 -12  -8   1  -5 -24   0  -5  -6 -24 -21 -11   3  17  -4 -35;...
    0  -9   5  16 -27  11  20  -2   0 -10 -17  -3 -12 -27  -6  -2  -5 -34 -20 -10  12  17  -5 -35;...
    4 -15   0   0 -17  -9  -2  22 -13 -15 -21 -11 -15 -22  -6   3  -3 -33 -26  -8   0  -5  -6 -35;...
   -9   5   8   1 -16  12   0 -13  30 -14 -11  -4 -14 -10  -3  -6  -9 -14  -1 -12   4   7  -5 -35;...
   -4 -10  -9 -13 -11 -12 -10 -15 -14  23   8 -10   8   2 -12  -9   0 -26  -8  16 -11 -11  -5 -35;...
  -10 -16 -15 -21 -30  -8 -17 -21 -11   8  25 -15  14   4 -13 -15 -10 -10  -8   5 -18 -13  -8 -35;...
   -8  13   4  -2 -27   1  -3 -11  -4 -10 -15  22   2 -26  -8  -3  -1 -19 -21 -14   1  -1  -6 -35;...
   -7  -3 -11 -15 -26  -5 -12 -15 -14   8  14   2  34  -2 -12  -9  -4 -22 -16   6 -13  -8  -5 -35;...
  -17 -21 -17 -28 -23 -24 -27 -22 -10   2   4 -26  -2  35 -22 -15 -16  -3  23  -9 -22 -26 -13 -35;...
    4  -3  -5  -8 -15   0  -6  -6  -3 -12 -13  -8 -12 -22  27   3  -1 -27 -25  -8  -7  -3  -5 -35;...
    5  -3   4  -1  -1  -5  -2   3  -6  -9 -15  -3  -9 -15   3  11   7 -11 -13  -7   2  -4  -2 -35;...
    6  -7   2  -3 -12  -6  -5  -3  -9   0 -10  -1  -4 -16  -1   7  16 -25 -13   0  -1  -6  -2 -35;...
  -27   6 -19 -32 -35 -24 -34 -33 -14 -26 -10 -19 -22  -3 -27 -11 -25  60  -5 -31 -24 -29 -20 -35;...
  -17 -21  -9 -21  -2 -21 -20 -26  -1  -8  -8 -21 -16  23 -25 -13 -13  -5  39 -14 -14 -20 -13 -35;...
    0 -14 -11 -13 -10 -11 -10  -8 -12  16   5 -14   6  -9  -8  -7   0 -31 -14  21 -12 -10  -5 -35;...
   -1  -7  12  16 -22   3  12   0   4 -11 -18   1 -13 -22  -7   2  -1 -24 -14 -12  15   9  -4 -35;...
   -1  -2   3  12 -27  17  17  -5   7 -11 -13  -1  -8 -26  -3  -4  -6 -29 -20 -10   9  17  -4 -35;...
   -2  -6  -2  -5 -16  -4  -5  -6  -5  -5  -8  -6  -5 -13  -5  -2  -2 -20 -13  -5  -4  -4  -6 -35;...
  -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35   1;...
    ];

if nargout >1
    matrixInfo.Name = 'PAM160CDI';
    matrixInfo.Scale = 0.1;
    matrixInfo.Entropy = 0.694 ;
    matrixInfo.ExpectedScore = -5.73;
    matrixInfo.LowestScore = -35;
    matrixInfo.HighestScore = 60;
    matrixInfo.Order = 'ARNDCQEGHILKMFPSTWYVBZX*';
end
