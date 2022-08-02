%%NAME
%%  eaxis - draw scaled axis
%%
%%SYNOPSIS
%%  valueTextPos=eaxis(xPos,yPos,length,type,scale[,angle[,color[,offset]]])
%%
%%PARAMETER(S)
%%  xPos         x-value of start position of axis
%%  yPos         y-value of start position of axis
%%  length       length  of axis 
%%  type         orientation 'w'=west, 'e'=east, 's'=south, 'n'=north 
%%  scale        vector of scaling, [startValue stepValue endValue]
%%  angle        angle to rotate axis 
%%  color        color of axis
%%  offset       offset of position 
%%  valueTextPos positions of values
%% 
%%GLOBAL PARAMETER(S)
%%  eAxesColor
%%  eAxesValueFontSize
%%  eAxesValueSpace
%%  eAxesLineWidth
%%  eAxesTicShortLength
%%  eAxesTicLongLength
%%  eAxesTicLongMaxN
%%  eXAxisSouthValueFormat
%%  eYAxisWestValueFormat
%%  eXAxisNorthValueFormat
%%  eYAxisEastValueFormat
%%  eXAxisSouthValueVisible
%%  eYAxisWestValueVisible
%%  eXAxisNorthValueVisible
%%  eYAxisEastValueVisible
%%  eXAxisSouthValuePos
%%  eYAxisWestValuePos
%%  eXAxisNorthValuePos
%%  eYAxisEastValuePos
%%  eXAxisSouthScaleType
%%  eYAxisWestScaleType
%%  eXAxisNorthScaleType
%%  eYAxisEastScaleType
%%
% written by stefan.mueller@fgan.de (C) 2007

function valueTextPos=eaxis(xPos,yPos,length,type,scale,angle,color,offset)
  eglobpar;
  if nargin>8 | nargin<5
    eusage('eaxis(xPos,yPos,length,type,scale[,angle[,color[,offset]]])');
  end
  if nargin<8
    offset=0;
  end
  if nargin<7
    color=eAxesColor;
  end 
  if nargin<6
    angle=0;
  end 
  if type=='s'
   valueFormat=eXAxisSouthValueFormat;
   valueVisible=eXAxisSouthValueVisible;
   scaleType=eXAxisSouthScaleType;
  elseif type=='w'
   valueFormat=eYAxisWestValueFormat;
   valueVisible=eYAxisWestValueVisible;
   scaleType=eYAxisWestScaleType;
  elseif type=='n'
   valueFormat=eXAxisNorthValueFormat;
   valueVisible=eXAxisNorthValueVisible;
   scaleType=eXAxisNorthScaleType;
  else
   valueFormat=eYAxisEastValueFormat;
   valueVisible=eYAxisEastValueVisible;
   scaleType=eYAxisEastScaleType;
  end

  if scaleType==0
    valueTextPos=escalexy(eFile,type,xPos*eFac,yPos*eFac,...
           offset,angle,length*eFac,scale(1),scale(2),scale(3),...
           valueFormat,valueVisible,...
           eAxesValueFontSize*eFac,...
           eAxesLineWidth*eFac,...
           eAxesTicShortLength*eFac,...
           eAxesTicLongLength*eFac,...
           eAxesTicLongMaxN,...
           eAxesValueSpace*eFac,...
           color);
  elseif scaleType==1
    valueTextPos=escalecl(eFile,type,xPos*eFac,yPos*eFac,...
           offset,angle,length*eFac,scale(1),scale(2),scale(3),...
           valueFormat,valueVisible,...
           eAxesValueFontSize*eFac,...
           eAxesLineWidth*eFac,...
           eAxesTicLongLength*eFac,...
           eAxesTicLongMaxN,...
           eAxesValueSpace*eFac,...
           color);
  elseif scaleType==2
    valueTextPos=escalelog(eFile,type,xPos*eFac,yPos*eFac,...
           offset,angle,length*eFac,scale(1),scale(2),scale(3),...
           valueFormat,valueVisible,...
           eAxesValueFontSize*eFac,...
           eAxesLineWidth*eFac,...
           eAxesTicShortLength*eFac,...
           eAxesTicLongLength*eFac,...
           eAxesTicLongMaxN,...
           eAxesValueSpace*eFac,...
           color);
  end
  valueTextPos=valueTextPos/eFac;
  if type=='s'
    eXAxisSouthValuePos=valueTextPos;
  elseif type=='w'
    eYAxisWestValuePos=valueTextPos;
  elseif type=='n'
    eXAxisNorthValuePos=valueTextPos;
  else
    eYAxisEastValuePos=valueTextPos;
  end
