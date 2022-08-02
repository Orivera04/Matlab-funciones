%%NAME
%%  einflate - inflate columns of matrix
%%
%%SYNOPSIS
%%  newMatrix=einflate(matrix[,exponent])
%%
%%PARAMETER(S)
%%  matrix      real matrix 
%%  exponent    exponent of factor 10^exponent
%%              default=2
%%  newMatrix   normalized new matrix
% written by Joerg Heckenbach and stefan.mueller@fgan.de (C) 2007
function newMatrix=einflate(matrix,exponent)
  if (nargin <2)
    exponent=2;
  end
  if (nargin <1)
    eusage('newMatrix = einflate(matrix,exponent)');
  end
  n=size(matrix,1);
  newMatrix=matrix.^exponent;
  factor=(max(matrix)./max(newMatrix))'*ones(1,n);
  newMatrix=newMatrix.*factor';
