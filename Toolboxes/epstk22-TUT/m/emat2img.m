%%NAME
%%  emat2img  - convert matrix to image
%%
%%SYNOPSIS
%%  [image colormap]=emat2img(matrix[,colormap[,scale]])
%%
%%PARAMETER(S)
%%  matrix             matrix for image 
%%  colormap           define own colormap  
%%  scale              scale vector of legend [start step end]
%%                      special cases of scale vector are:
%%                      if start=0 and end=0 then autorange=on 
%%                      if step=0 then autoscale=on
%%                      (default scale vector=[0 0 0])
%%  image              created image
%%
%%GLOBAL PARAMETER(S)
%%  eImageDefaultColorMap
%%  eImageLegendScale
% written by stefan.mueller@fgan.de (C) 2006

function [image colormap]=emat2img(matrix,colormap,scale)
  if (nargin>3)
    eusage('[image colormap]=emat2img(matrix[,colormap[,scale]])');
  end
  eglobpar;
  if exist('eFac')
    if isempty(eFac)
      einit;
    end
  else
    einit;
  end
  if nargin<3
    scale=eImageLegendScale;
  end
  if nargin<2
    colormap=ecolors(eImageDefaultColorMap);
  end
  if nargin<1
    [matrix colormap]=eppmread([ePath 'default.ppm']);
    ePlotTitleText='Photo';
  end
  
  % scale image
  mSize=size(matrix);
  matrix=reshape(matrix,mSize(1)*mSize(2),1);
  minval=min (matrix);
  maxval=max (matrix);
  if scale(1)~=scale(3)
    if scale(1)>minval
      pos=find(matrix<scale(1));
      matrix(pos)=scale(1);
    end
    minval=scale(1);
    if scale(3)<maxval
      pos=find(matrix>scale(3));
      matrix(pos)=scale(3);
    end
    maxval=scale(3);
  end

  matrix=reshape(matrix,mSize(1),mSize(2));
  if eImageLegendScaleType==2
    minval=log10(minval);
    maxval=log10(maxval);
    matrix=log10(matrix);
  end
  if (maxval - minval)<=1000*eps
    maxval=minval+1000*eps;
  end
  image = fix ((matrix - minval) / (maxval - minval) *...
        (length (colormap) - 1)) + 1;
