%%NAME
%%  epolar - make polar plot 
%%
%%SYNOPSIS
%%  epolar ([xData,[yData,[legendText,[dash,[color[,width]]]]])
%%
%%PARAMETER(S)
%%  xData          vector of alpha-data in rad
%%  yData          vector of radia-data  
%%  legendText     text of legend, if empty  string then no legend
%%  dash           0=solid line,>0=dash length,
%%                 <0=fill line,string=name of symbol
%%                 if a vector with size 1xn, then dash describes
%%                   a dash combination [space lineLength1 lineLength2 ...]
%%  color          color of plot, vetcor [r g b]
%%  width          width of plot
%% 
%%GLOBAL PARAMETER(S)
%%  ePolarAxisRadScale
%%  ePolarAxisAngScale
%%  ePolarPlotAreaCenterPos
%%  ePolarPlotAreaRadMax
%%  ePolarPlotAreaValStart
%%  ePolarPlotAreaValEnd
%%  ePolarPlotAreaAngStart;
%%  ePolarPlotAreaAngEnd
%%  ePolarPlotAreaRadMax
%%  ePolarPlotAreaRadMin
%%  ePlotLegendPos
%%  ePlotLegendTextFont
%%  ePlotLegendFontSize
%%  ePlotLegendDistance;
%%  ePlotLineWidth
%%  ePlotLineColor; 
%%  ePlotLineDash; 
%%  eAxesColor; 
% written by stefan.mueller@fgan.de (C) 2007

function epolar(xData,yData,legendText,dash,color,width)
  if nargin>6
    eusage('epolar([xData,[yData,[legendText,[dash,[color[,width]]]]])');
  end
  eglobpar;
  if (nargin==0)
    %finish plotting
    
    % write title
    eptitle;

    %value range
    if ePolarAxisRadScale(1)~=ePolarAxisRadScale(3)
      %fix scale 
      ePolarPlotAreaValStart=ePolarAxisRadScale(1);
      ePolarPlotAreaValEnd=ePolarAxisRadScale(3);
    end
    if ePolarAxisRadScaleType==2
      if(ePolarPlotAreaValStart>0)&(ePolarPlotAreaValEnd>0)
         ePolarPlotAreaValStart=log10(ePolarPlotAreaValStart);
         ePolarPlotAreaValEnd=log10(ePolarPlotAreaValEnd);
      else
        error('yValues<=0');
      end
    end
    yRange=ePolarPlotAreaValEnd-ePolarPlotAreaValStart;
    if yRange==0
      yRange=1;
    end
    if ePolarAxisAngScale(1)==ePolarAxisAngScale(3)
      ePolarAxisAngScale(1)=0;
      ePolarAxisAngScale(3)=ePolarPlotAreaAngEnd-ePolarPlotAreaAngStart;
    end
    egridpol;
    eaxespol;
      
    % plot line and write legend
    ePolarPlotAreaFac=(ePolarPlotAreaRadMax-ePolarPlotAreaRadMin)*...
                       eFac/yRange;
    legendPos=ePlotLegendPos;
    for i=1:ePolarPlotLineNo
      parameter=sprintf('global ePolarPlotLineW%d;',i);
      eval(parameter);
      parameter=sprintf('width=ePolarPlotLineW%d;',i);
      eval(parameter);
      parameter=sprintf('global ePolarPlotLineC%d;',i);
      eval(parameter);
      parameter=sprintf('color=ePolarPlotLineC%d;',i);
      eval(parameter);
      parameter=sprintf('global ePolarPlotLineDash%d;',i);
      eval(parameter);
      parameter=sprintf('dash=ePolarPlotLineDash%d;',i);
      eval(parameter);
      parameter=sprintf('global ePolarPlotLegText%d;',i);
      eval(parameter);
      parameter=sprintf('legendText=ePolarPlotLegText%d;',i);
      eval(parameter);
      parameter=sprintf('global ePolarPlotXData%d;',i);
      eval(parameter);
      parameter=sprintf('xData=ePolarPlotXData%d;',i);
      eval(parameter);
      parameter=sprintf('global ePolarPlotYData%d;',i);
      eval(parameter);
      parameter=sprintf('yData=ePolarPlotYData%d;',i);
      eval(parameter);
      xData=xData+ePolarPlotAreaAngStart;
      if ePolarAxisRadScaleType==2
        yData=log10(yData);
      end
      yData=(yData-ePolarPlotAreaValStart)*ePolarPlotAreaFac+...
             ePolarPlotAreaRadMin*eFac;
      eclippol(eFile,...
              ePolarPlotAreaCenterPos(1)*eFac,...
              ePolarPlotAreaCenterPos(2)*eFac,...
              ePolarPlotAreaRadMin*eFac,...
              ePolarPlotAreaRadMax*eFac,...
              ePolarPlotAreaAngStart,...
              ePolarPlotAreaAngEnd);
      if isstr(dash)
        epolplos(eFile,...
          ePolarPlotAreaCenterPos(1)*eFac,...
          ePolarPlotAreaCenterPos(2)*eFac,...
          xData,...
          yData,...
          dash,...
          color)
      elseif dash<0;
        epolplof(eFile,...
          ePolarPlotAreaCenterPos(1)*eFac,...
          ePolarPlotAreaCenterPos(2)*eFac,...
          xData,...
          yData,...
          color)
      else
        epolplot(eFile,...
          ePolarPlotAreaCenterPos(1)*eFac,...
          ePolarPlotAreaCenterPos(2)*eFac,...
          xData,...
          yData,...
          color,...
          dash*eFac,...
          width*eFac);
      end
      eclippol(eFile);

      if strcmp(legendText,'')~=1
        eplotlg(eFile,...
          (ePolarPlotAreaCenterPos(1)-ePolarPlotAreaRadMax+legendPos(1))*...
          eFac,...
          (ePolarPlotAreaCenterPos(2)-ePolarPlotAreaRadMax+legendPos(2))*...
          eFac,...
          color,... 
          dash,...
          width*eFac,...
          legendText,...
          eFonts(ePlotLegendTextFont,:),...
          ePlotLegendFontSize*eFac,eAxesColor);
        legendPos(2)=legendPos(2)-ePlotLegendDistance/70*ePlotLegendFontSize;
      end
    end
    ePolarPlotLineNo=0;
  else    
    % add plot line
    ePolarPlotLineNo=ePolarPlotLineNo+1;
    %width
    if (nargin<6)
      width=ePlotLineWidth; 
    end
    parameter=sprintf('global ePolarPlotLineW%d;',ePolarPlotLineNo);
    eval(parameter);
    parameter=sprintf('ePolarPlotLineW%d=width;',ePolarPlotLineNo);
    eval(parameter);
    %color
    if (nargin<5)
      color=ePlotLineColor; 
    end
    parameter=sprintf('global ePolarPlotLineC%d;',ePolarPlotLineNo);
    eval(parameter);
    parameter=sprintf('ePolarPlotLineC%d=color;',ePolarPlotLineNo);
    eval(parameter);
    
    %dash
    if (nargin<4)
      dash=ePlotLineDash; 
    end
    parameter=sprintf('global ePolarPlotLineDash%d;',ePolarPlotLineNo);
    eval(parameter);
    parameter=sprintf('ePolarPlotLineDash%d=dash;',ePolarPlotLineNo);
    eval(parameter);
  
    % legend text
    if (nargin<3)
      legendText='';
    end
    parameter=sprintf('global ePolarPlotLegText%d;',ePolarPlotLineNo);
    eval(parameter);
    parameter=sprintf('ePolarPlotLegText%d=legendText;',ePolarPlotLineNo);
    eval(parameter);
  
    if (nargin==1)
      yData=xData;
      xStep=length(yData)/(ePolarPlotAreaAngEnd-ePolarPlotAreaAngStart)
      xData=1:length(yData);
    else
      rad2deg=180/pi;
      xData=xData*rad2deg;
    end
    % data
    parameter=sprintf('global ePolarPlotXData%d;',ePolarPlotLineNo);
    eval(parameter);
    parameter=sprintf('ePolarPlotXData%d=xData;',ePolarPlotLineNo);
    eval(parameter);
    parameter=sprintf('global ePolarPlotYData%d;',ePolarPlotLineNo);
    eval(parameter);
    parameter=sprintf('ePolarPlotYData%d=yData;',ePolarPlotLineNo);
    eval(parameter);
  
    %value range
    yMin=min(yData);
    yMay=max(yData);
    if yMin<ePolarPlotAreaValStart | ePolarPlotLineNo==1
      ePolarPlotAreaValStart=yMin;
    end
    if yMay>ePolarPlotAreaValEnd | ePolarPlotLineNo==1
      ePolarPlotAreaValEnd=yMay;
    end
  end
