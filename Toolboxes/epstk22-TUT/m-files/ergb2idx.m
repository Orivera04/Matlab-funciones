%%NAME
%%  ergb2idx  - covert RGB-matrix to index-matrix 
%%
%%SYNOPSIS
%%  [image,colormap]=ergb2idx(matrix)
%%
%%PARAMETER(S)
%%  matrix      RBG-matrix 
%%  image       index-matrix 
%%  colormap    color table
%% 
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003
function [image,colormap]= ergb2idx (matrix)
  if (nargin ~= 1)
    eusage('[image,colormap] = ergb2idx(matrix)');
  end

  [rows cols]= size(matrix);
  matrix=reshape(matrix,rows*cols,1);

  % generate colormap
  [cmap index]=sort(matrix);
  change=diff(cmap);
  dIndex=[1;find(change)+1];
  colorId=cmap(dIndex);
  colormap=matrix(index(dIndex));
  rColor=fix(colormap/65536);
  colormap=colormap-rColor*65536;
  gColor=fix(colormap/256);
  bColor=colormap-gColor*256;
  colormap=[rColor gColor bColor]/255;

  % generate image 
  dIndex=[dIndex;size(cmap,1)+1];
  for i=1:size(colorId,1)
    matrix(index(dIndex(i):dIndex(i+1)-1))=i;
  end 
  image=reshape(matrix,rows,cols); 
