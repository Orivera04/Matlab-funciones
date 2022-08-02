%%NAME
%%  etitle - print title of plot
%%
%%SYNOPSIS
%%  etitle ([text[,distance[,fontSize[,color]]]])
%%
%%PARAMETER(S)
%%  text     title text
%%  distance distance from plot area
%%  fontSize fontsize of text
%%  color of text
%%
%%GLOBAL PARAMETER(S)
%%  ePlotTitleText
%%  ePlotTitleDistance
%%  ePlotTitleFontSize
%%  ePlotTitleTextFont
%%  ePlotAreaPos
%%  ePlotAreaWidth
%%  ePlotAreaHeight
%%  eTextColor
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function etitle(text,distance,fontSize,color)
  if  nargin >4
    eusage('etitle([text[,distance[,fontSize[,color]]]])');
  end
  eglobpar;
  if nargin<4
    color=eTextColor;
  end
  if nargin<3
    fontSize=ePlotTitleFontSize;
  end
  if nargin<2
    distance=ePlotTitleDistance;
  end
  if nargin<1
    text=ePlotTitleText;
  end
  if strcmp(text,'')~=1
    etext(text,ePlotAreaPos(1)+ePlotAreaWidth/2,...
       ePlotAreaPos(2)+ePlotAreaHeight+distance,...
       fontSize,0,ePlotTitleTextFont,0,color);
  end
