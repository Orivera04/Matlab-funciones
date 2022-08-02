%%NAME
%%  eshadoix  - mix a shadow image with a cover image  
%%
%%SYNOPSIS
%%  [x colorMapNew]=eshadoix(matrix,coverImg,colorMap) 
%%
%%PARAMETER(S)
%%  matrix             matrix to calculate the shadow image 
%%  coverImg           matrix for cover image 
%%                     each value of this matrix is a row index of the colormap
%%  colorMap           colormap of coverImg 
%%
%%  x                  mix shadow image matrix
%%  colorMapNew        colormap of x
%%      special case of return parameters:
%%      if the return parameters are used then no output
%%
% written by stefan.mueller@fgan.de (C) 2007

function [x,colorMapNew]=eshadoix(matrix,coverImg,colorMap)
  if nargin ~= 3
    eusage('[x colorMapNew]=eshadoix(matrix,coverImg,coloMap)');
  end
  eglobpar;
  if sum(2*colorMap(:,1)-colorMap(:,2)-colorMap(:,3))
    nColors=size(colorMap,1); 
    nBrL=64;
    minFac=0.4;
    colorMapNew=colorMap*(minFac+(1-minFac)*1/nBrL);
    for i=2:nBrL
      colorMapNew=[colorMapNew;colorMap*(minFac+(1-minFac)*i/nBrL)];
    end
  else
    nColors=1;
    colorMapNew=colorMap;
  end
  x=eshadow(matrix,nColors,colorMapNew,[1 1 1],coverImg);
  if nargout==0
    eimage(x,colorMapNew);
  end

