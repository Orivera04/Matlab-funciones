%%NAME
%%  eidx2rgb  - covert  index-matrix to RGB-matrix 
%%
%%SYNOPSIS
%%  matrix=eidx2rgb(image,colormap)
%%
%%PARAMETER(S)
%%  image       index-matrix 
%%  colormap    color table
%%  matrix      RBG-matrix 
%% 
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003
function matrix= eidx2rgb (image,colormap)
  if (nargin ~= 2)
    eusage('matrix = eidx2rgb(image,colormap)');
  end

  [rows cols]= size(image)
  colormap=fix(colormap*255);
  colormap=colormap*[65536;256;1];
  image=reshape(image,rows*cols,1);
  image=colormap(image);
  matrix=reshape(image,rows,cols);
