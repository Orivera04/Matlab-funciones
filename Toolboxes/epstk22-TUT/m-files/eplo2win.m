%%NAME
%%  eplo2win - transform coordinates , plotarea to window 
%%
%%SYNOPSIS
%%  [winX winY]=eplo2win(ploX,plotY)
%%
%%PARAMETER(S)
%%  ploX     x-vector of coordinates of plotarea
%%  ploY     y-vector of coordinates of plotarea
%%  winX     x-vector of coordinates of window
%%  winY     y-vector of coordinates of window
%% 
%%GLOBAL PARAMETER(S)
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function [winX,winY]=eplo2win(ploX,ploY)
  if nargin~=2
    eusage('[winX winY]=eplo2win(ploX,ploY)');
  end
  eglobpar;
  if  eXAxisSouthScaleType==2
    ploX=log10(ploX);
  end
  if  eYAxisWestScaleType==2
    ploY=log10(ploY);
  end
  xFac=ePlotAreaWidth/...
      (ePlotAreaXValueEnd-ePlotAreaXValueStart);
  yFac=ePlotAreaHeight/...
      (ePlotAreaYValueEnd-ePlotAreaYValueStart);        
  winX=ePlotAreaPos(1)+(ploX-ePlotAreaXValueStart)*xFac;
  winY=ePlotAreaPos(2)+(ploY-ePlotAreaYValueStart)*yFac;
