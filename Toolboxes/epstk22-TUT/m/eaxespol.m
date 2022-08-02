%%NAME
%%  eaxespol - draw scaled axes and arc around polar plot area 
%%
%%SYNOPSIS
%%  eaxespol([axisRadiusScale,axisAngleScale])
%%
%%PARAMETER(S)
%%  axisRadiusScale   scale vector of radius axis  [start step end] 
%%  axisAngleScale    scale vector of angle circle [start step end] 
%% 
%%    special cases of scale vectors are: 
%%      if start=0 and end=0 then autorange=on
%%      if step=0 then autoscale=on
%%                                          
%%GLOBAL PARAMETER(S)
%%  ePolarPlotAreaCenterPos
%%  ePolarPlotAreaRadMin
%%  ePolarPlotAreaRadMax
%%  ePolarPlotAreaAngStart
%%  ePolarPlotAreaAngEnd
%%  ePolarPlotAreaValStart
%%  ePolarPlotAreaValEnd
%%  ePolarAxisRadScale
%%  ePolarAxisRadVisible
%%  ePolarAxisRadValueFormat
%%  ePolarAxisRadValueVisible
%%  ePolarAxisRadPos
%%  ePolarAxisAngScale
%%  ePolarAxisAngVisible
%%  ePolarAxisAngValueFormat
%%  ePolarAxisAngValueVisible
%%  ePolarAxisAngValueAngle
%%  eAxesValueFontSize
%%  eAxesColor
%%  eAxesLineWidth
%%  eAxesTicShortLength
%%  eAxesTicLongLength
%%  eAxesTicLongMaxN
%%  eAxesValueSpace
% written by stefan.mueller@fgan.de (C) 2007

function eaxespol(axisRadiusScale,axisAngleScale)
  if nargin~=0 & nargin~=2
    eusage('egridpol([axisRadiusScale,axisAngleScale])');
  end
  eglobpar;
  if nargin==2
    ePolarAxisRadScale=axisRadiusScale;
    ePolarPlotAreaValStart=ePolarAxisRadScale(1);
    ePolarPlotAreaValEnd=ePolarAxisRadScale(3);
    ePolarAxisAngScale=axisAngleScale;
    yRange=ePolarPlotAreaValEnd-ePolarPlotAreaValStart;
    if yRange==0
      yRange=1;
    end
    ePolarPlotAreaFac=(ePolarPlotAreaRadMax-ePolarPlotAreaRadMin)*...
                      eFac/yRange;
  end
  if ePolarAxisRadScale(1)~=ePolarAxisRadScale(3)
    ePolarPlotAreaValStart=ePolarAxisRadScale(1);
    ePolarPlotAreaValEnd=ePolarAxisRadScale(3);
  end
    ePolarPlotAreaValStart
    ePolarPlotAreaValEnd
  % scale and draw axes
  saveTypeE=eYAxisEastScaleType;
  saveVisibleE=eYAxisEastValueVisible;
  saveValuePosE=eYAxisEastValuePos;
  saveTypeW=eYAxisWestScaleType;
  saveVisibleW=eYAxisWestValueVisible;
  saveValuePosW=eYAxisWestValuePos;
  saveTypeN=eXAxisNorthScaleType;
  saveVisibleN=eXAxisNorthValueVisible;
  saveValuePosN=eXAxisNorthValuePos;
  saveTypeS=eXAxisSouthScaleType;
  saveVisibleS=eXAxisSouthValueVisible;
  saveValuePosS=eXAxisSouthValuePos;
  ePolarAxisRadValuePos=[0 0];
  if rem(ePolarAxisRadVisible,2)
    angle=rem(ePolarPlotAreaAngStart,360);
    if (angle>45) & (angle<=135)
      eYAxisEastValueVisible=rem(ePolarAxisRadValueVisible,2);
      eYAxisEastScaleType=ePolarAxisRadScaleType;
      st='e';
      aa=-90;
    elseif (angle>135) & (angle<=225)
      eXAxisNorthValueVisible=rem(ePolarAxisRadValueVisible,2);
      eXAxisNorthScaleType=ePolarAxisRadScaleType;
      st='n';
      aa=180;
    elseif (angle>225) & (angle<=315)
      eYAxisWestValueVisible=rem(ePolarAxisRadValueVisible,2);
      eYAxisWestScaleType=ePolarAxisRadScaleType;
      st='w';
      aa=90;
    elseif (angle>315) || (angle<=45)
      eXAxisSouthValueVisible=rem(ePolarAxisRadValueVisible,2);
      eXAxisSouthScaleType=ePolarAxisRadScaleType;
      st='s';
      aa=0;
    end
    if (angle>315) || (angle<135)
      scale=[ePolarPlotAreaValStart...
             ePolarAxisRadScale(2)...
             ePolarPlotAreaValEnd];
      rr=ePolarPlotAreaRadMin;
      ePolarAxisRadValuePos=eaxis(ePolarPlotAreaCenterPos(1)+...
        cos(pi*angle/180)*rr,...
        ePolarPlotAreaCenterPos(2)+sin(pi*angle/180)*rr,...
        ePolarPlotAreaRadMax-ePolarPlotAreaRadMin,st,...
        scale,angle+aa,eAxesColor,0);
    else
      scale=[ePolarPlotAreaValEnd...
             -ePolarAxisRadScale(2)...
             ePolarPlotAreaValStart];
      rr=ePolarPlotAreaRadMax;
      ePolarAxisRadValuePos=eaxis(ePolarPlotAreaCenterPos(1)+...
        cos(pi*angle/180)*rr,...
        ePolarPlotAreaCenterPos(2)+sin(pi*angle/180)*rr,...
        ePolarPlotAreaRadMax-ePolarPlotAreaRadMin,st,...
        scale,angle+aa,eAxesColor,0);
    end
  end

  if fix(ePolarAxisRadVisible/2)
    nPos=size(ePolarAxisRadValuePos,1);
    angle=rem(ePolarPlotAreaAngEnd,360);
    if (angle>45) & (angle<=135)
      eYAxisWestValueVisible=fix(ePolarAxisRadValueVisible/2);
      eYAxisWestScaleType=ePolarAxisRadScaleType;
      st='w';
      aa=-90;
    elseif (angle>135) & (angle<=225)
      eXAxisSouthValueVisible=fix(ePolarAxisRadValueVisible/2);
      eXAxisSouthScaleType=ePolarAxisRadScaleType;
      st='s';
      aa=180;
    elseif (angle>225) & (angle<=315)
      eYAxisEastValueVisible=fix(ePolarAxisRadValueVisible/2);
      eYAxisEastScaleType=ePolarAxisRadScaleType;
      st='e';
      aa=90;
    elseif (angle>315) || (angle<=45)
      eXAxisNorthValueVisible=fix(ePolarAxisRadValueVisible/2);
      eXAxisNorthScaleType=ePolarAxisRadScaleType;
      st='n';
      aa=0;
    end
    if (angle>315) || (angle<135)
      scale=[ePolarPlotAreaValStart...
             ePolarAxisRadScale(2)...
             ePolarPlotAreaValEnd];
      rr=ePolarPlotAreaRadMin;
      valuePos=eaxis(ePolarPlotAreaCenterPos(1)+cos(pi*angle/180)*rr,...
        ePolarPlotAreaCenterPos(2)+sin(pi*angle/180)*rr,...
        ePolarPlotAreaRadMax-ePolarPlotAreaRadMin,st,...
        scale,angle+aa,eAxesColor,0);
      if nPos==size(valuePos,1)
        ePolarAxisRadValuePos=[ePolarAxisRadValuePos valuePos];
      else
        ePolarAxisRadValuePos=valuePos;
      end
    else
      scale=[ePolarPlotAreaValEnd...
             -ePolarAxisRadScale(2)...
             ePolarPlotAreaValStart];
      rr=ePolarPlotAreaRadMax;
      valuePos=eaxis(ePolarPlotAreaCenterPos(1)+cos(pi*angle/180)*rr,...
        ePolarPlotAreaCenterPos(2)+sin(pi*angle/180)*rr,...
        ePolarPlotAreaRadMax-ePolarPlotAreaRadMin,st,...
        scale,angle+aa,eAxesColor,0);
      if nPos==size(valuePos,1)
        ePolarAxisRadValuePos=[ePolarAxisRadValuePos valuePos];
      else
        ePolarAxisRadValuePos=valuePos;
      end
    end
  end
  
  eYAxisEastValueVisibleE=saveVisibleE;
  eYAxisEastValuePos=saveValuePosE;
  eYAxisEastScaleType=saveTypeE;
  eYAxisWestValueVisibleW=saveVisibleW;
  eYAxisWestValuePos=saveValuePosW;
  eYAxisWestScaleType=saveTypeW;
  eXAxisNorthScaleType=saveTypeN;
  eXAxisNorthValueVisible=saveVisibleN;
  eXAxisNorthValuePos=saveValuePosN;
  eXAxisSouthScaleType=saveTypeS;
  eXAxisSouthValueVisible=saveVisibleS;
  eXAxisSouthValuePos=saveValuePosS;

  if ePolarAxisAngVisible
    maxValues=fix(20*(ePolarPlotAreaAngEnd-ePolarPlotAreaAngStart)/360);
    ePolarAxisAngValueAngle=escalepa(eFile,...
            ePolarPlotAreaCenterPos(1)*eFac,...
            ePolarPlotAreaCenterPos(2)*eFac,...
            ePolarPlotAreaRadMin*eFac,...
            ePolarPlotAreaRadMax*eFac,...
            ePolarPlotAreaAngStart,...
            ePolarPlotAreaAngEnd,...
            ePolarAxisAngScale(1),...
            ePolarAxisAngScale(2),...
            ePolarAxisAngScale(3),...
            ePolarAxisAngValueFormat,...
            ePolarAxisAngValueVisible,...
            eAxesValueFontSize*eFac,...
            eAxesLineWidth*eFac,...
            eAxesTicShortLength*eFac,...
            eAxesTicLongLength*eFac,...
            maxValues,...
            eAxesValueSpace*eFac,...
            eAxesColor);
  end
