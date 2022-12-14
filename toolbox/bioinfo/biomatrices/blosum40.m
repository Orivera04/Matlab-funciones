function [matrix, matrixInfo]  = blosum40
%BLOSUM40 Clustered Scoring Matrix in 1/4 Bit Units
%   Blocks Database = /data/blocks_5.0/blocks.dat
%   Cluster Percentage: >= 40
%   Entropy =   0.2851, Expected Score =  -0.2090
%   Lowest Score = -6, Highest Score = 19
%
%   Order:
%   A  R  N  D  C  Q  E  G  H  I  L  K  M  F  P  S  T  W  Y  V  B  Z  X  *
%
%   [MATRIX,MATRIXINFO] = BLOSUM40 returns a structure of information about
%   the matrix with fields Name, Scale, Entropy, Expected and Order.

% Source:  ftp://ftp.ncbi.nih.gov/blast/matrices/
%   $Revision: 1.5 $ 

matrix = [...
   5 -2 -1 -1 -2  0 -1  1 -2 -1 -2 -1 -1 -3 -2  1  0 -3 -2  0 -1 -1  0 -6 ;...
  -2  9  0 -1 -3  2 -1 -3  0 -3 -2  3 -1 -2 -3 -1 -2 -2 -1 -2 -1  0 -1 -6 ;...
  -1  0  8  2 -2  1 -1  0  1 -2 -3  0 -2 -3 -2  1  0 -4 -2 -3  4  0 -1 -6 ;...
  -1 -1  2  9 -2 -1  2 -2  0 -4 -3  0 -3 -4 -2  0 -1 -5 -3 -3  6  1 -1 -6 ;...
  -2 -3 -2 -2 16 -4 -2 -3 -4 -4 -2 -3 -3 -2 -5 -1 -1 -6 -4 -2 -2 -3 -2 -6 ;...
   0  2  1 -1 -4  8  2 -2  0 -3 -2  1 -1 -4 -2  1 -1 -1 -1 -3  0  4 -1 -6 ;...
  -1 -1 -1  2 -2  2  7 -3  0 -4 -2  1 -2 -3  0  0 -1 -2 -2 -3  1  5 -1 -6 ;...
   1 -3  0 -2 -3 -2 -3  8 -2 -4 -4 -2 -2 -3 -1  0 -2 -2 -3 -4 -1 -2 -1 -6 ;...
  -2  0  1  0 -4  0  0 -2 13 -3 -2 -1  1 -2 -2 -1 -2 -5  2 -4  0  0 -1 -6 ;...
  -1 -3 -2 -4 -4 -3 -4 -4 -3  6  2 -3  1  1 -2 -2 -1 -3  0  4 -3 -4 -1 -6 ;...
  -2 -2 -3 -3 -2 -2 -2 -4 -2  2  6 -2  3  2 -4 -3 -1 -1  0  2 -3 -2 -1 -6 ;...
  -1  3  0  0 -3  1  1 -2 -1 -3 -2  6 -1 -3 -1  0  0 -2 -1 -2  0  1 -1 -6 ;...
  -1 -1 -2 -3 -3 -1 -2 -2  1  1  3 -1  7  0 -2 -2 -1 -2  1  1 -3 -2  0 -6 ;...
  -3 -2 -3 -4 -2 -4 -3 -3 -2  1  2 -3  0  9 -4 -2 -1  1  4  0 -3 -4 -1 -6 ;...
  -2 -3 -2 -2 -5 -2  0 -1 -2 -2 -4 -1 -2 -4 11 -1  0 -4 -3 -3 -2 -1 -2 -6 ;...
   1 -1  1  0 -1  1  0  0 -1 -2 -3  0 -2 -2 -1  5  2 -5 -2 -1  0  0  0 -6 ;...
   0 -2  0 -1 -1 -1 -1 -2 -2 -1 -1  0 -1 -1  0  2  6 -4 -1  1  0 -1  0 -6 ;...
  -3 -2 -4 -5 -6 -1 -2 -2 -5 -3 -1 -2 -2  1 -4 -5 -4 19  3 -3 -4 -2 -2 -6 ;...
  -2 -1 -2 -3 -4 -1 -2 -3  2  0  0 -1  1  4 -3 -2 -1  3  9 -1 -3 -2 -1 -6 ;...
   0 -2 -3 -3 -2 -3 -3 -4 -4  4  2 -2  1  0 -3 -1  1 -3 -1  5 -3 -3 -1 -6 ;...
  -1 -1  4  6 -2  0  1 -1  0 -3 -3  0 -3 -3 -2  0  0 -4 -3 -3  5  2 -1 -6 ;...
  -1  0  0  1 -3  4  5 -2  0 -4 -2  1 -2 -4 -1  0 -1 -2 -2 -3  2  5 -1 -6 ;...
   0 -1 -1 -1 -2 -1 -1 -1 -1 -1 -1 -1  0 -1 -2  0  0 -2 -1 -1 -1 -1 -1 -6 ;...
  -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6  1 ;...
    ];
if nargout >1
    matrixInfo.Name = 'BLOSUM40';
    matrixInfo.Scale = 1/4;
    matrixInfo.Entropy = 0.2851;
    matrixInfo.ExpectedScore =  -0.2090;
    matrixInfo.HighestScore = 19;
    matrixInfo.LowestScore = -6;
    matrixInfo.Order = 'ARNDCQEGHILKMFPSTWYVBZX*';
end