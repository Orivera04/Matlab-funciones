%%NAME
%%  ematrsnn  - resize matrix with nearest neighbor interpolation 
%%
%%SYNOPSIS
%%  newMatrix=ematrsnn(matrix,newRows,newCols)
%%
%%PARAMETER(S)
%%  matrix        old matrix
%%  newRows       number of rows of new matrix
%%  newCols       number of cols of new matrix
%%  newMatrix     interpolated matrix
%%
% written by stefan.mueller@fgan.de (C) 2006
function newMatrix=ematrsnn(matrix,newRows,newCols)
   if (nargin ~= 3)
    eusage('newMatrix=ematrsnn(natrix,newRows,newCols)');
  end
  [rows cols]=size(matrix);
  if newRows>2 & newCols>2
    rFac=(rows-1)/(newRows-1);
    cFac=(cols-1)/(newCols-1);
    newMatrix=zeros(newRows,newCols);
    idxR=1:newRows;
    idxC=1:newCols;
    oIdxR=round((idxR-1)*rFac+1);
    oIdxC=round((idxC-1)*cFac+1);
    newMatrix(idxR,idxC)=matrix(oIdxR,oIdxC);
  else
    disp('to less rows or cols');
    newMatrix=zeros(newRows,newCols);
  end
