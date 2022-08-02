%%NAME
%%  epline  - draw polyline 
%%
%%SYNOPSIS
%%  epline(xData,yData[,lineWidth[,dash[,color]]])
%%
%%PARAMETER(S)
%%  xData       vector of x-values of polyline
%%  yData       vector of y-values of polyline
%%  lineWidth   width of polyline 
%%              default: lineWidth=eLineWidth
%%  dash          if a scalar and
%%                  dash=0  solid lines,
%%                  dash>0  dash length
%%                  dash<0  fill polylines with color
%%                default: dash=eLineDash
%%                if a vector with size 1xn, then dash describes
%%                  a dash combination [space lineLength1 lineLength2 ...]
%%                if a matrix and color=-1
%%                  dash is the image of polyline 
%%                  and filled with RGB values
%%                  (value=R*2^16+G*2^8+B and R,G,B are integer of 0:255)
%%                if a matrix and color is a colormap
%%                  dash is the image of polyline 
%%                  and filled with indices of colormap
%%                if a string then dash is filename of a JPEG-file
%%  color         if dash>=0 vector of frame color ([r g b])
%%                if dash<0  vector of background color
%%                if dash a matrix then colormap of image or -1
%%                default: dash=eLineColor
%% 
%%GLOBAL PARAMETER(S)
%%  eLineColor
%%  eLineDash
%%  eLineWidth
% written by stefan.mueller@fgan.de (C) 2007

function epline (xData,yData,lineWidth,dash,color)
  if nargin<2 | nargin>5
    eusage('epline(xData,yData,[,lineWidth[,dash[,color]]])');
  end
  eglobpar;
  if nargin<5
    color=eLineColor;
  end
  if nargin<4
    dash=eLineDash;
  end
  if nargin<3
    lineWidth=eLineWidth;
  end
  xData=xData*eFac;
  yData=yData*eFac;
  if (size(dash,1)>1) &&  (size(dash,2)>1)
    exyploti(eFile,0,0,xData,yData,dash,color);
  else
    if dash<0
      exyplotf(eFile,0,0,xData,yData,color,ePlotLineInterpolation);
    else
      exyplot( eFile,0,0,xData,yData,color,dash*eFac,...
             lineWidth*eFac,ePlotLineInterpolation);
    end
  end
