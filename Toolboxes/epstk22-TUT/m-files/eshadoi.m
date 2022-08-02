%%NAME
%%  eshadoi  - draw shadow image of a matrix 
%%
%%SYNOPSIS
%%  [x,colorMapNew]=eshadoi(matrix[,colorMap])
%%
%%PARAMETER(S)
%%  matrix             matrix for image 
%%                     each value of the matrix is a row index of the colormap
%%  colorMap           define own colormap  
%%
%%  if the next return parameters are used then no output
%%  x                  shadow image matrix
%%  colorMapNew        colormap of x
%%
%%GLOBAL PARAMETER(S)
%%  eImageDefaultColorMap
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function [x,colorMapNew]=eshadoi(matrix,colorMap)
  if nargin >2
    eusage('[x,colorMapNew]=eshadoi(matrix[,coloMap])');
  end
  eglobpar;
  if nargin==0
    x=-3*pi:0.1:3*pi;
    [a b]=meshgrid(x,x);
    R=sqrt(a.^2+b.^2) + eps;
    matrix=sin(R)./R;
  end
  if nargin<2
    colorMap=ecolors(eImageDefaultColorMap);
  end
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
  x=eshadow(matrix,nColors,colorMapNew,[1 1 1]);
  if nargout==0
    eimage(x,colorMapNew);
  end
