%%NAME
%%  eparam  -  print parameter text in two columns under plots 
%%
%%SYNOPSIS
%%  eparam(text1,text2[,x,y])
%%
%%PARAMETER(S)
%%  text1        text of the left column
%%  text2        text of the right column
%%  x            x-coordinate of start position
%%  y            y-coordinate of start position
%% 
%%GLOBAL PARAMETER(S)
%%  eParamPos
%%  eParamFontSize
%%  eParamTextValueDistance
%%  eParamTextFont
%%  eParamValueFont
%%  eParamLineDistance
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function eparam(text1,text2,x,y)
  if nargin~=2 & nargin~=4 
    eusage('eparam(text1,text2[,x,y])');
  end
  eglobpar;
  if nargin<4 
    x=eParamPos(1);
    y=eParamPos(2);
  else
    eParamPos(1)=x;
    eParamPos(2)=y;
  end
  lineDistance=eParamLineDistance/100*eParamFontSize;
  valueDistance=eParamTextValueDistance/20*eParamFontSize;
  valueOffset=eParamFontSize; 
  [xw yh]=etabdef(1,3,x,y,2*valueDistance,eParamFontSize,[10 1 10]);
  etabtext(xw,yh,1,1,text1,-1,eParamTextFont);
  etabtext(xw,yh,1,2,':',0,eParamTextFont);
  etabtext(xw,yh,1,3,text2,1,eParamValueFont);
  eParamPos(2)=eParamPos(2)-lineDistance;
