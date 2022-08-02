%%NAME
%%  eimg2txt  - converts image to ascii-image 
%%
%%SYNOPSIS
%%  txt=eimg2txt(image,colormap)
%%
%%PARAMETER(S)
%%  txt         string of image 
%%  image       index-matrix 
%%  colormap    color table
%% 
% written by stefan.mueller@fgan.de (C) 2007
function txt= eimg2txt (image,colormap)
  if (nargin ~= 2)
    eusage('txt = eimg2txt(image,colormap)');
  end
  if colormap(1,1)<0
    [image colormap]=ergb2idx(image);
  end

  txtTab=['NBW8OUGX0woscvx+!~"-,' setstr(39) '`  ']; 
  [rows cols]=size(image);
  lumen=reshape(colormap(image,1)+...
                colormap(image,2)+...
                colormap(image,3),rows,cols);
  lumen=reshape([lumen;lumen],rows,2*cols);
  maxL=max(max(lumen));minL=min(min(lumen));
  lumen=(lumen-minL)/(maxL-minL+eps);
  txt=txtTab(fix(lumen*length(txtTab))+1);
