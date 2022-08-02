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
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

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
  % scale and draw axes
  saveTypeE=eYAxisEastScaleType;
  saveVisibleE=eYAxisEastValueVisible;
  saveValuePosE=eYAxisEastValuePos;
  eYAxisEastScaleType=ePolarAxisRadScaleType;
  saveTypeW=eYAxisWestScaleType;
  saveVisibleW=eYAxisWestValueVisible;
  saveValuePosW=eYAxisWestValuePos;
  eYAxisWestScaleType=ePolarAxisRadScaleType;
  ePolarAxisRadValuePos=[0 0];
  if rem(ePolarAxisRadVisible,2)
    angle=rem(ePolarPlotAreaAngStart,360);
    if (angle>=0) & (angle<=180)
      eYAxisEastValueVisible=rem(ePolarAxisRadValueVisible,2);
      scale=[ePolarPlotAreaValStart...
             ePolarAxisRadScale(2)...
             ePolarPlotAreaValEnd];
      rr=ePolarPlotAreaRadMin;
      aa=-90;
      eaxis(ePolarPlotAreaCenterPos(1)+cos(pi*angle/180)*rr,...
          ePolarPlotAreaCenterPos(2)+sin(pi*angle/180)*rr,...
          ePolarPlotAreaRadMax-ePolarPlotAreaRadMin,'e',...
          scale,angle+aa,eAxesColor,0);
      ePolarAxisRadValuePos=eYAxisEastValuePos;
    else
      eYAxisWestValueVisible=rem(ePolarAxisRadValueVisible,2);
      scale=[ePolarPlotAreaValEnd...
             -ePolarAxisRadScale(2)...
             ePolarPlotAreaValStart];
      rr=ePolarPlotAreaRadMax;
      aa=90;
      eaxis(ePolarPlotAreaCenterPos(1)+cos(pi*angle/180)*rr,...
          ePolarPlotAreaCenterPos(2)+sin(pi*angle/180)*rr,...
          ePolarPlotAreaRadMax-ePolarPlotAreaRadMin,'w',...
          scale,angle+aa,eAxesColor,0);
      ePolarAxisRadValuePos=eYAxisWestValuePos;
    end
  end

  if fix(ePolarAxisRadVisible/2)
    nPos=size(ePolarAxisRadValuePos,1);
    angle=rem(ePolarPlotAreaAngEnd,360);
    if (angle>=0) & (angle<=180)
      eYAxisWestValueVisible=fix(ePolarAxisRadValueVisible/2);
      scale=[ePolarPlotAreaValStart...
             ePolarAxisRadScale(2)...
             ePolarPlotAreaValEnd];
      rr=ePolarPlotAreaRadMin;
      aa=-90;
      eaxis(ePolarPlotAreaCenterPos(1)+cos(pi*angle/180)*rr,...
          ePolarPlotAreaCenterPos(2)+sin(pi*angle/180)*rr,...
          ePolarPlotAreaRadMax-ePolarPlotAreaRadMin,'w',...
          scale,angle+aa,eAxesColor,0);
      if nPos==size(eYAxisWestValuePos,1)
        ePolarAxisRadValuePos=[ePolarAxisRadValuePos eYAxisWestValuePos];
      else
        ePolarAxisRadValuePos=eYAxisWestValuePos;
      end
    else
      eYAxisEastValueVisible=fix(ePolarAxisRadValueVisible/2);
      scale=[ePolarPlotAreaValEnd...
             -ePolarAxisRadScale(2)...
             ePolarPlotAreaValStart];
      rr=ePolarPlotAreaRadMax;
      aa=90;
      eaxis(ePolarPlotAreaCenterPos(1)+cos(pi*angle/180)*rr,...
          ePolarPlotAreaCenterPos(2)+sin(pi*angle/180)*rr,...
          ePolarPlotAreaRadMax-ePolarPlotAreaRadMin,'e',...
          scale,angle+aa,eAxesColor,0);
      if nPos==size(eYAxisEastValuePos,1)
        ePolarAxisRadValuePos=[ePolarAxisRadValuePos eYAxisEastValuePos];
      else
        ePolarAxisRadValuePos=eYAxisEastValuePos;
      end
    end
  end
  
  eYAxisEastValueVisibleE=saveVisibleE;
  eYAxisEastValuePos=saveValuePosE;
  eYAxisEastScaleType=saveTypeE;
  eYAxisWestValueVisibleW=saveVisibleW;
  eYAxisWestValuePos=saveValuePosW;
  eYAxisWestScaleType=saveTypeW;

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
