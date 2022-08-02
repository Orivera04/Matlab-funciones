%%NAME
%%  ematrsli  - resize matrix with linear interpolation 
%%
%%SYNOPSIS
%%  newMatrix=ematrsli(matrix,newRows,newCols)
%%
%%PARAMETER(S)
%%  matrix        old matrix
%%  newRows       number of rows of new matrix
%%  newCols       number of cols of new matrix
%%  newMatrix     interpolated matrix
%%
% written by stefan.mueller@fgan.de (C) 2006
function newMatrix=ematrsli(matrix,newRows,newCols)
  if (nargin ~= 3)
   eusage('newMatrix=ematrsli(natrix,newRows,newCols)');
  end
  [rows cols]=size(matrix); 
  if  rows>cols
    if rows~=newRows
      newMatrix=zeros(newRows,cols);
      newIdxR=1:newRows-1;
      fac=(rows-1)/(newRows-1);
      oldR=(newIdxR-1)*fac+1;
      oldIdxR=floor(oldR);
      dy=matrix(2:rows,:)-matrix(1:rows-1,:);
      dx=(oldR-oldIdxR)'*ones(1,cols);
      delta=dx.*dy(oldIdxR,:);
      newMatrix(newIdxR,:)=matrix(oldIdxR,:)+delta;
      newMatrix(newRows,:)=matrix(rows,:);
      matrix=newMatrix;
      rows=newRows;
    end
    if cols~=newCols
      newMatrix=zeros(rows,newCols);
      newIdxC=1:newCols-1;
      fac=(cols-1)/(newCols-1);
      oldC=(newIdxC-1)*fac+1;
      oldIdxC=floor(oldC);
      dy=matrix(:,2:cols)-matrix(:,1:cols-1);
      dx=(oldC-oldIdxC)'*ones(1,rows);
      delta=dx'.*dy(:,oldIdxC);
      newMatrix(:,newIdxC)=matrix(:,oldIdxC)+delta;
      newMatrix(:,newCols)=matrix(:,cols);
    end
  else
    if cols~=newCols
      newMatrix=zeros(rows,newCols);
      newIdxC=1:newCols-1;
      fac=(cols-1)/(newCols-1);
      oldC=(newIdxC-1)*fac+1;
      oldIdxC=floor(oldC);
      dy=matrix(:,2:cols)-matrix(:,1:cols-1);
      dx=(oldC-oldIdxC)'*ones(1,rows);
      delta=dx'.*dy(:,oldIdxC);
      newMatrix(:,newIdxC)=matrix(:,oldIdxC)+delta;
      newMatrix(:,newCols)=matrix(:,cols);
      matrix=newMatrix;
      cols=newCols;
    end
    if rows~=newRows
      newMatrix=zeros(newRows,cols);
      newIdxR=1:newRows-1;
      fac=(rows-1)/(newRows-1);
      oldR=(newIdxR-1)*fac+1;
      oldIdxR=floor(oldR);
      dy=matrix(2:rows,:)-matrix(1:rows-1,:);
      dx=(oldR-oldIdxR)'*ones(1,cols);
      delta=dx.*dy(oldIdxR,:);
      newMatrix(newIdxR,:)=matrix(oldIdxR,:)+delta;
      newMatrix(newRows,:)=matrix(rows,:);
    end
  end
