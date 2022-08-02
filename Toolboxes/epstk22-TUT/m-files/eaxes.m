%%NAME
%%  eaxes - draw scaled axes around plot area
%%
%%SYNOPSIS
%%  eaxes ([xAxisSouthScale,yAxisWestScale[,xAxisNorthScale,yAxisEastScale]])
%%
%%PARAMETER(S)
%%  xAxisSouthScale   scale vector of south axis [start step end]
%%  yAxisWestScale    scale vector of west axis  [start step end]
%%  xAxisNorthScale   scale vector of north axis [start step end]
%%  yAxisEastScale    scale vector of east axis  [start step end]
%%
%%    special cases of scale vectors are:
%%      if start=0 and end=0 then autorange=on 
%%      if step=0 then autoscale=on
%%    (default scale vector=[0 0 0])
%%
%%GLOBAL PARAMETER(S)
%%  ePlotAreaXValueStart
%%  ePlotAreaXValueEnd
%%  ePlotAreaYValueStart
%%  ePlotAreaYValueEnd
%%  ePlotAreaPos
%%  ePlotAreaWidth
%%  ePlotAreaHeight
%%  eAxesValueFontSize
%%  eAxesValueSpace
%%  eAxesColor
%%  eAxesLineWidth
%%  eAxesTicShortLength
%%  eAxesTicLongLength
%%  eAxesTicLongMaxN
%%  eAxesCrossOrigin
%%  eAxesValueSpace
%%  eAxesLabelFontSize
%%  eAxesLabelTextFont
%%  eXAxis(South|West|East|North)Scale
%%  eXAxis(South|West|East|North)ScaleType
%%  eXAxis(South|West|East|North)Visible
%%  eXAxis(South|West|East|North)ValueFormat
%%  eXAxis(South|West|East|North)ValueVisible
%%  eXAxis(South|West|East|North)LabelText
%%  eXAxis(South|West|East|North)LabelDistance
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function eaxes(xAxisSouthScale,yAxisWestScale,xAxisNorthScale,yAxisEastScale)
  if nargin~=0 & nargin~=2 & nargin~=4
    eusage('eaxes([xAxisSouthScale,yAxisWestScale[,xAxisNorthScale,yAxisEastScale]])');
  end
  eglobpar;
  if nargin>0
    eXAxisSouthScale=xAxisSouthScale;
    if eXAxisSouthScaleType==2
      if (eXAxisSouthScale(1)>0)&(eXAxisSouthScale(3)>0)
        eXAxisSouthScale(1)=log10(eXAxisSouthScale(1));
        eXAxisSouthScale(3)=log10(eXAxisSouthScale(3));
      else
        error('xValues<=0 for log scale');
      end
    end
    if eXAxisSouthScale(1)==eXAxisSouthScale(3)
      eXAxisSouthScale(3)=eXAxisSouthScale(1)+1;
      eXAxisSouthScale(2)=0;
    end
    ePlotAreaXFac=ePlotAreaWidth*eFac/...
      (eXAxisSouthScale(3)-eXAxisSouthScale(1));

    eYAxisWestScale=yAxisWestScale;
    if eYAxisWestScaleType==2
      if (eYAxisWestScale(1)>0)&(eYAxisWestScale(3)>0)
        eYAxisWestScale(1)=log10(eYAxisWestScale(1));
        eYAxisWestScale(3)=log10(eYAxisWestScale(3));
      else
        error('yValues<=0 for log scale');
      end
    end
    if eYAxisWestScale(1)==eYAxisWestScale(3)
      eYAxisWestScale(3)=eYAxisWestScale(1)+1;
      eYAxisWestScale(2)=0;
    end
    ePlotAreaYValueEnd=eYAxisWestScale(3);
    ePlotAreaYFac=ePlotAreaHeight*eFac/...
      (eYAxisWestScale(3)-eYAxisWestScale(1));
  end
  if nargin>2
    eXAxisNorthScale=xAxisNorthScale;
    eYAxisEastScale=yAxisEastScale;
  end
  if eXAxisSouthScale(1)~=eXAxisSouthScale(3)
    ePlotAreaXValueStart=eXAxisSouthScale(1);
    ePlotAreaXValueEnd=eXAxisSouthScale(3);
  end
  if eYAxisWestScale(1)~=eYAxisWestScale(3)
    ePlotAreaYValueStart=eYAxisWestScale(1);
    ePlotAreaYValueEnd=eYAxisWestScale(3);
  end
  if eXAxisNorthScale(1)~=eXAxisNorthScale(3)
    if eXAxisNorthScaleType==2
      if (eXAxisNorthScale(1)>0)&(eXAxisNorthScale(3)>0)
        eXAxisNorthScale(1)=log10(eXAxisNorthScale(1));
        eXAxisNorthScale(3)=log10(eXAxisNorthScale(3));
      else
        error('xValues<=0 for log scale');
      end
    end
    eXAxisNorthValueStart=eXAxisNorthScale(1);
    eXAxisNorthValueEnd=eXAxisNorthScale(3);
  else
    eXAxisNorthValueStart=ePlotAreaXValueStart;
    eXAxisNorthValueEnd=ePlotAreaXValueEnd;
    eXAxisNorthScale=eXAxisSouthScale;
    eXAxisNorthScaleType=eXAxisSouthScaleType;
  end
  if eYAxisEastScale(1)~=eYAxisEastScale(3)
    if eYAxisEastScaleType==2
      if (eYAxisEastScale(1)>0)&(eYAxisEastScale(3)>0)
        eYAxisEastScale(1)=log10(eYAxisEastScale(1));
        eYAxisEastScale(3)=log10(eYAxisEastScale(3));
      else
        error('yValues<=0 for log scale');
      end
    end
    eYAxisEastValueStart=eYAxisEastScale(1);
    eYAxisEastValueEnd=eYAxisEastScale(3);
  else
    eYAxisEastValueStart=ePlotAreaYValueStart;
    eYAxisEastValueEnd=ePlotAreaYValueEnd;
    eYAxisEastScale=eYAxisWestScale;
    eYAxisEastScaleType=eYAxisWestScaleType;
  end
  
  
  if sign(ePlotAreaXValueStart*ePlotAreaXValueEnd)<0 &...
     sign(ePlotAreaYValueStart*ePlotAreaYValueEnd)<0 & eAxesCrossOrigin
    eXAxisSouthVisible=1;
    eYAxisWestVisible=1;
    eXAxisNorthVisible=0;
    eYAxisEastVisible=0;
    xAxisOffset=-ePlotAreaYValueStart*ePlotAreaYFac;   
    yAxisOffset=-ePlotAreaXValueStart*ePlotAreaXFac;   
    if eAxesCrossOrigin==2
      edsymbol('arrow','spire.psd',eAxesLineWidth,eAxesLineWidth,0,0,0,eAxesColor);
      esymbol(ePlotAreaPos(1)+ePlotAreaWidth,...
          ePlotAreaPos(2)+xAxisOffset/eFac,'arrow');
      esymbol(ePlotAreaPos(1)+yAxisOffset/eFac,...
          ePlotAreaPos(2)+ePlotAreaHeight,'arrow',1,1,90);
    end
  else
    xAxisOffset=0;
    yAxisOffset=0;
  end
  % scale and draw axes
  if eXAxisSouthVisible
    eaxis(ePlotAreaPos(1),ePlotAreaPos(2),...
          ePlotAreaWidth,'s',...
          [ePlotAreaXValueStart eXAxisSouthScale(2)  ePlotAreaXValueEnd],...
          0,eAxesColor,-xAxisOffset);
  end
  if eXAxisNorthVisible
    eaxis(ePlotAreaPos(1),ePlotAreaPos(2)+ePlotAreaHeight,...
          ePlotAreaWidth,'n',...
          [eXAxisNorthValueStart eXAxisNorthScale(2)  eXAxisNorthValueEnd],...
          0,eAxesColor,0);
  end
  if eYAxisWestVisible
    eaxis(ePlotAreaPos(1),ePlotAreaPos(2),...
          ePlotAreaHeight,'w',...
          [ePlotAreaYValueStart eYAxisWestScale(2)  ePlotAreaYValueEnd],...
          0,eAxesColor,-yAxisOffset);
  end
  if eYAxisEastVisible
    eaxis(ePlotAreaPos(1)+ePlotAreaWidth,ePlotAreaPos(2),...
          ePlotAreaHeight,'e',...
          [eYAxisEastValueStart eYAxisEastScale(2)  eYAxisEastValueEnd],...
          0,eAxesColor,0);
  end

  %print labels
  scaleSpace=eAxesTicLongLength+eAxesValueSpace+eAxesValueFontSize;
  if strcmp(eXAxisSouthLabelText,'')~=1
    etext(eXAxisSouthLabelText,...
          ePlotAreaPos(1)+ePlotAreaWidth/2,...
          ePlotAreaPos(2)-scaleSpace-...
          eAxesLabelFontSize*0.72-eXAxisSouthLabelDistance,...
          eAxesLabelFontSize,0,eAxesLabelTextFont,0,eAxesColor);
  end
  if strcmp(eXAxisNorthLabelText,'')~=1
    etext(eXAxisNorthLabelText,...
          ePlotAreaPos(1)+ePlotAreaWidth/2,...
          ePlotAreaPos(2)+ePlotAreaHeight+...
          scaleSpace+eXAxisNorthLabelDistance,...
          eAxesLabelFontSize,0,eAxesLabelTextFont,0,eAxesColor);
  end
  if strcmp(eYAxisWestLabelText,'')~=1
    etext(eYAxisWestLabelText,...
          ePlotAreaPos(1)-scaleSpace-eYAxisWestLabelDistance,...
          ePlotAreaPos(2)+ePlotAreaHeight/2,...
          eAxesLabelFontSize,0,eAxesLabelTextFont,90,eAxesColor);
  end
  if strcmp(eYAxisEastLabelText,'')~=1
    etext(eYAxisEastLabelText,...
          ePlotAreaPos(1)+ePlotAreaWidth+scaleSpace+...
          eAxesLabelFontSize/2+eYAxisEastLabelDistance,...
          ePlotAreaPos(2)+ePlotAreaHeight/2,...
          eAxesLabelFontSize,0,eAxesLabelTextFont,90,eAxesColor);
  end
