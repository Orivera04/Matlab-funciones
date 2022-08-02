%%NAME
%%  eptitle - print title of polar plot
%%
%%SYNOPSIS
%%  eptitle ([text[,distance[,fontSize]]])
%%
%%PARAMETER(S)
%%  text     title text
%%  distance distance from plot area
%%  fontSize fontsize of text
%%
%%GLOBAL PARAMETER(S)
%%  ePlotTitleText
%%  ePlotTitleDistance
%%  ePlotTitleFontSize
%%  ePlotTitleTextFont
%%  ePolarPlotAreaCenterPos
%%  ePolarPlotAreaRadMax
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function eptitle(text,distance,fontSize)
  if  nargin >3
    eusage('eptitle([text[,distance[,fontSize]]])');
  end
  eglobpar;
  if nargin<3
    fontSize=ePlotTitleFontSize;
  end
  if nargin<2
    distance=ePlotTitleDistance;
  end
  if nargin<1
    text=ePlotTitleText;
  end
  if strcmp(ePlotTitleText,'')~=1
    etext(ePlotTitleText,ePolarPlotAreaCenterPos(1),...
         ePolarPlotAreaCenterPos(2)+ePolarPlotAreaRadMax+...
         ePlotTitleDistance,ePlotTitleFontSize,0,ePlotTitleTextFont,0);
  end
