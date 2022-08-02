%%NAME
%%  egridpol - draw polar grid 
%%
%%SYNOPSIS
%%  egridpol ([axisRadiusScale,axisAngleScale])
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
%%  ePolarPlotAreaValStart
%%  ePolarPlotAreaValEnd
%%  ePolarPlotAreaCenterPos
%%  ePolarPlotAreaRadMin
%%  ePolarPlotAreaRadMax
%%  ePolarPlotAreaAngStart
%%  ePolarPlotAreaAngEnd
%%  ePolarAxisRadScale
%%  ePolarAxisAngScale
%%  ePolarRadiusGridVisible
%%  ePolarRadiusGridLineWidth
%%  ePolarRadiusGridColor
%%  ePolarRadiusGridDash
%%  ePolarAngleGridVisible
%%  ePolarAngleGridLineWidth
%%  ePolarAngleGridColor
%%  ePolarAngleGridDash
%%  eAxesTicLongMaxN
%%
% written by stefan.mueller@fgan.de (C) 2007

function egridpol(axisRadiusScale,axisAngleScale)
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
  if nargin==0
    if ePolarAxisRadScale(1)~=ePolarAxisRadScale(3)
      ePolarPlotAreaValStart=ePolarAxisRadScale(1);
      ePolarPlotAreaValEnd=ePolarAxisRadScale(3);
    end
    % scale and draw grids 
    if ePolarRadiusGridVisible
      egridpr(eFile,...
              ePolarPlotAreaCenterPos(1)*eFac,...
              ePolarPlotAreaCenterPos(2)*eFac,...
              ePolarPlotAreaRadMin*eFac,...
              ePolarPlotAreaRadMax*eFac,...
              ePolarPlotAreaAngStart,...
              ePolarPlotAreaAngEnd,...
              ePolarPlotAreaValStart,...
              ePolarAxisRadScale(2),...
              ePolarPlotAreaValEnd,...
              eAxesTicLongMaxN,...
              ePolarRadiusGridLineWidth*eFac,...
              ePolarRadiusGridColor,...
              ePolarRadiusGridDash*eFac);
    end
    if ePolarAngleGridVisible
      maxValues=fix(20*(ePolarPlotAreaAngEnd-ePolarPlotAreaAngStart)/360);
      egridpa(eFile,...
              ePolarPlotAreaCenterPos(1)*eFac,...
              ePolarPlotAreaCenterPos(2)*eFac,...
              ePolarPlotAreaRadMin*eFac,...
              ePolarPlotAreaRadMax*eFac,...
              ePolarPlotAreaAngStart,...
              ePolarPlotAreaAngEnd,...
              ePolarAxisAngScale(1),...
              ePolarAxisAngScale(2),...
              ePolarAxisAngScale(3),...
              maxValues,...
              ePolarAngleGridLineWidth*eFac,...
              ePolarAngleGridColor,...
              ePolarAngleGridDash*eFac);
    end
  end
