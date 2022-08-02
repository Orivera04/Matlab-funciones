%%NAME
%%  emerge  - merge matrix
%%
%%SYNOPSIS
%%  matrixNew=emerge(matrixOld,key[,direction])
%%
%%PARAMETER(S)
%%  matrixOld      nxm matrix
%%  key            vector of integer for merging (can be used as key)
%%  direction      1 merge forward, -1 merge backward,default=1
%%
% written by stefan.mueller@fgan.de (C) 2007
function matrix=emerge(matrix,key,direction)
  if nargin<2
    eusage('matrixNew=emerge(matrixOld,key[,direction])');
  end
  if nargin<3
    direction=1;
  end
  [rows cols]=size(matrix);
  n=rows*cols;
  kl=length(key);
  if direction>0
    for j=1:2
      for i=1:cols
        matrix(:,i)=circshift(matrix(:,i),i*key(rem(i,kl)+1));
      end
      for i=1:rows
        matrix(i,:)=circshift(matrix(i,:)',i*key(rem(i,kl)+1))';
      end
    end
  else
    for j=1:2
      for i=1:rows
        matrix(i,:)=circshift(matrix(i,:)',-i*key(rem(i,kl)+1))';
      end
      for i=1:cols
        matrix(:,i)=circshift(matrix(:,i),-i*key(rem(i,kl)+1));
      end
    end
  end
