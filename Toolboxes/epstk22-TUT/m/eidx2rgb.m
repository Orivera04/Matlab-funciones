%%NAME
%%  eidx2rgb  - converts index-matrix to RGB-matrix 
%%
%%SYNOPSIS
%%  matrix=eidx2rgb(image,colormap)
%%
%%PARAMETER(S)
%%  image       index-matrix 
%%  colormap    color table
%%  matrix      RBG-matrix 
%% 
% written by stefan.mueller@fgan.de (C) 2007
function matrix= eidx2rgb (image,colormap)
  if (nargin ~= 2)
    eusage('matrix = eidx2rgb(image,colormap)');
  end

  [rows cols]= size(image);
  colormap=fix(colormap*255);
  colormap=bitshift(colormap(:,1),16)+...
           bitshift(colormap(:,2),8)+...
	   colormap(:,3);
  image=reshape(image,rows*cols,1);
  image=colormap(image);
  matrix=reshape(image,rows,cols);
