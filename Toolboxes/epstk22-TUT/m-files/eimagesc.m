%%NAME
%%  eimagesc  - draw scaled image of a matrix 
%%
%%SYNOPSIS
%%  x=eimagesc(matrix[,colorMap[,legendOrientation[,legendScale]]])
%%
%%PARAMETER(S)
%%  x                  transformed output matrix with values of color numbers
%%  matrix             matrix for image 
%%  colorMap           define own colormap  
%%  legendOrientation  side of the image where the legend appears 
%%                     character 's'(south),'n'(north),'w'(west) or 'e'(east) 
%%                     (default orientation is south)
%%  legendScale        scale vector of legend [start step end]
%%                     special cases of scale vector are:
%%                     if start=0 and end=0 then autorange=on 
%%                     if step=0 then autoscale=on
%%                     (default scale vector=[0 0 0])
%%
%%GLOBAL PARAMETER(S)
%%  ePlotAreaPos
%%  ePlotAreaWidth
%%  ePlotAreaHeight
%%  eImageDefaultColorMap
%%  eImageLegendScale
%%  eYAxisWestScale
%%  eXAxisSouthScale
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function x=eimagesc(matrix,colorMap,legendOrientation,legendScale)
  if (nargin>4)
    eusage('x=eimagesc(matrix[,colorMap[,legendOrientation[,legendScale]]])');
  end
  eglobpar;
  if nargin<4
    legendScale=eImageLegendScale;
  end
  if nargin<3
    legendOrientation='s';
  end
  if nargin<2
    colorMap=ecolors(eImageDefaultColorMap);
  end
  if nargin<1
    [matrix colorMap]=eppmread([ePath 'default.ppm']);
    ePlotTitleText='Photo';
  end
  
  % scale image
  if legendScale(1)==legendScale(3)
    minval=min (min (matrix));
    maxval=max (max (matrix));
  else
    minval=legendScale(1);
    maxval=legendScale(3);
  end
  if eImageLegendScaleType==2
    minval=log10(minval);
    maxval=log10(maxval);
    matrix=log10(matrix);
  end
  legendScale(1)=minval;
  legendScale(3)=maxval;
  if (maxval - minval)<=1000*eps
    maxval=minval+1000*eps;
  end
  x = fix ((matrix - minval) / (maxval - minval) *...
        (length (colorMap) - 1)) + 1;
  eimage(x,colorMap)

  % image axes
  if eYAxisWestScale(1)==eYAxisWestScale(3)
    eYAxisWestScale=[size(matrix,1) 0 0];
  end
  if eXAxisSouthScale(1)==eXAxisSouthScale(3)
    eXAxisSouthScale=[0 0 size(matrix,2)];
  end
  egrid;
  eaxes;

  % color legend
  eimgleg(ePlotAreaPos(1),ePlotAreaPos(2),ePlotAreaWidth,ePlotAreaHeight,...
          colorMap,legendScale,legendOrientation);
