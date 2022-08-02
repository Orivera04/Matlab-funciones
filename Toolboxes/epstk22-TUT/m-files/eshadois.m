%%NAME
%%  eshadois - draw scaled shadow image of a matrix 
%%
%%SYNOPSIS
%%  [x colorMapNew]=eshadois(matrix[,colorMap[,legendOrientation[,legendScale]]])
%%
%%PARAMETER(S)
%%  matrix             matrix for image 
%%  colorMap           define own colormap  
%%  legendOrientation  side of the image where the legend appears 
%%                     character 's'(south),'n'(north),'w'(west) or 'e'(east) 
%%                     (default orientation is east)
%%  legendScale        scale vector of legend [start step end]
%%                     special cases of scale vector are:
%%                     if start=0 and end=0 then autorange=on 
%%                     if step=0 then autoscale=on
%%                     (default scale vector=[0 0 0])
%%
%%  if the next return parameters are used then no output
%%  x                  scaled shadow image matrix
%%  colorMapNew        colormap of x
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

function [x,colorMapNew]=eshadois(matrix,colorMap,legendOrientation,legendScale)
  if nargin >4
    eusage('[x colorMapNew]=eshadois(matrix[,coloMap[,legendOrientation[,legendScale]]])');
  end
  eglobpar;
  if nargin<4
    legendScale=eImageLegendScale;
  end
  if nargin<3
    legendOrientation='e';
  end
  if nargin<2
    colorMap=ecolors(eImageDefaultColorMap);
  end
  if nargin==0
    x=-3*pi:0.1:3*pi;
    [a b]=meshgrid(x,x);
    R=sqrt(a.^2+b.^2) + eps;
    matrix=sin(R)./R;
    colorMap=[1 1 0;1 0 0;0 1 0;0 0 1;1 0 1];
  end

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
  [x colorMapNew]=eshadoi(matrix,colorMap);	
  
  if nargout==0 & sum(2*colorMap(:,1)-colorMap(:,2)-colorMap(:,3))
    %image
    eimage(x,colorMapNew);	
  
    % image axes
    if eYAxisWestScale(1)==eYAxisWestScale(3)
      eYAxisWestScale=[0 0 size(matrix,1)];
    end
    if eXAxisSouthScale(1)==eXAxisSouthScale(3)
      eXAxisSouthScale=[0 0 size(matrix,2)];
    end
    egrid;
    eaxes;
    
    % color legend
    eimgleg(ePlotAreaPos(1),ePlotAreaPos(2),ePlotAreaWidth,ePlotAreaHeight,...
      colorMap,legendScale,legendOrientation);
  end
