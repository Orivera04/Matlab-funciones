%%NAME
%%  elines  - draw lines 
%%
%%SYNOPSIS
%%  elines(xData,yData[,lineWidth[,dash[,color]]])
%%
%%PARAMETER(S)
%%  xData       matrix(2xn) of x0,x1-data of lines
%%  yData       matrix(2xn) of y0,y1-data of lines
%%  lineWidth   width of lines 
%%              default: lineWidth=eLineWidth
%%  dash        if dash=0 then draw solid lines
%%              else value of dash is the distance of dashes 
%%              default: dash=eLineDash
%%              if a vector with size 1xn, then dash describes
%%                a dash combination [space lineLength1 lineLength2 ...]
%%  color       vector of line color ([r g b])
%%              default: color=eLineColor
%% 
%%GLOBAL PARAMETER(S)
%%  eLineWidth
%%  eLineDash
%%  eLineColor
% written by stefan.mueller@fgan.de (C) 2007

function elines (xData,yData,lineWidth,dash,color)
  if nargin<2 | nargin>5
    eusage('elines(xData,yData,[,lineWidth[,dash[,color]]])');
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
  [xr xc]=size(xData);
  if xr>2
    xData=xData';
    xc=xr;
  end
  xData=reshape(xData,1,2*xc);
  [yr yc]=size(yData);
  if yr>2
    yData=yData';
    yc=yr;
  end
  yData=reshape(yData,1,2*yc);
    exyline(eFile,0,0,xData*eFac,yData*eFac,...
            color,dash*eFac,lineWidth*eFac);
