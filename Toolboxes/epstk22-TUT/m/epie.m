%%NAME
%%  epie - draw a pie chart 
%%
%%SYNOPSIS
%%  angles=epie([value[,valueText[,legendText[,dash[,offset[,color]]]]]])
%%
%%PARAMETER(S)
%%  value          value of pie slide 
%%  valueText      text of value , if empty  string then no text at pie slice
%%  legendText     text of legend, if empty  string then no legend
%%  dash           border type,0=solid line,>0=dash length,
%%                 <0=fill slice with color
%%  offset         radial offset of pieslice, default=0
%%  color          color of pie, vector [r g b]
%%  angles         n x 2 matrix of pie slice angles, if epie without parameter
%%                 [pieSlice1StartAngle pieSlice1SizeAngle;
%%                  pieSlice2StartAngle ... 
%% 
%%GLOBAL PARAMETER(S)
%%  ePolarPlotAreaCenterPos
%%  ePolarPlotAreaRadMax
%%  ePolarPlotAreaValStart
%%  ePolarPlotAreaValEnd
%%  ePolarPlotAreaAngStart;
%%  ePolarPlotAreaAngEnd
%%  ePolarPlotAreaRadMax
%%  ePolarPlotAreaRadMin
%%  ePlotLegendTextFont
%%  ePlotLegendFontSize
%%  ePlotLineDash; 
%%  ePlotLineDash;
%%  eAxesTicLongLength
%%  eAxesValueSpace
%%  eAxesValueFontSize
%%  eAxesLineWidth
%%  eAxesColor
%%  ePolarAxisRadScale
%%  ePolarAxisAngScale
%%
% written by stefan.mueller@fgan.de (C) 2007 

function angles=epie(value,valueText,legendText,dash,offset,color)
  if nargin>6
    eusage('angles=epie([value[,valueText[,legendText[,dash[,offset[,color]]]]]])');
  end
  eglobpar;
  if (nargin==0)
    %finish plotting 
    
    % write title
    eptitle;
    angles=zeros(ePieSliceNo,2);
    legendPos=ePlotLegendPos;
    for i=1:ePieSliceNo
      parameter=sprintf('global ePieSliceW%d;',i);
      eval(parameter);
      parameter=sprintf('width=ePieSliceW%d;',i);
      eval(parameter);
      parameter=sprintf('global ePieSliceC%d;',i);
      eval(parameter);
      parameter=sprintf('color=ePieSliceC%d;',i);
      eval(parameter);
      parameter=sprintf('global ePieSliceDash%d;',i);
      eval(parameter);
      parameter=sprintf('dash=ePieSliceDash%d;',i);
      eval(parameter);
      parameter=sprintf('global ePieSliceLegText%d;',i);
      eval(parameter);
      parameter=sprintf('legendText=ePieSliceLegText%d;',i);
      eval(parameter);
      parameter=sprintf('global ePieSliceValue%d;',i);
      eval(parameter);
      parameter=sprintf('value=ePieSliceValue%d;',i);
      eval(parameter);
      parameter=sprintf('global ePieSliceValueText%d;',i);
      eval(parameter);
      parameter=sprintf('valueText=ePieSliceValueText%d;',i);
      eval(parameter);
      parameter=sprintf('global ePieSliceOffset%d;',i);
      eval(parameter);
      parameter=sprintf('offset=ePieSliceOffset%d;',i);
      eval(parameter);
      pieSize=ePolarPlotAreaAngEnd-ePolarPlotAreaAngStart; 
      pieSliceSize=pieSize*value/ePolarPlotAreaValStart;
      if i==1 
        angle=ePolarPlotAreaAngStart;
      end
      angles(i,:)=[angle pieSliceSize];
      if size(dash,1)==1
        dash=dash*eFac;
      end
      epiesxy(eFile,...
              ePolarPlotAreaCenterPos(1)*eFac,...
              ePolarPlotAreaCenterPos(2)*eFac,...
              ePolarPlotAreaRadMin*eFac,...
              ePolarPlotAreaRadMax*eFac,...
              angle,...
              pieSliceSize,...
              color,...
              dash,...
              width*eFac,...
              offset*eFac);

      if strcmp(valueText,'')~=1
        degAngle=rem(angle+pieSliceSize/2+360,360);
        vTextAngle=degAngle*pi/180; 
        cossin=[cos(vTextAngle) sin(vTextAngle)];
        vTextR1=(ePolarPlotAreaRadMax+offset)*cossin;
        vTextR2=vTextR1+eAxesTicLongLength*cossin;
        vTextR3=vTextR2+eAxesValueSpace*cossin;
        pos1=ePolarPlotAreaCenterPos+vTextR1;
        pos2=ePolarPlotAreaCenterPos+vTextR2;
        pos3=ePolarPlotAreaCenterPos+vTextR3;
        elines([pos1(1);pos2(1)],[pos1(2);pos2(2)],eAxesLineWidth,0,eAxesColor);
        if ((degAngle<=60) & (degAngle>=0)) | ...
           ((degAngle<360) & (degAngle>300)) 
          yShift=-eAxesValueFontSize/4;
          al=1;
        end
        if (degAngle<=120) & (degAngle>60)
          al=0;
          yShift=0;
        end
        if (degAngle<=240) & (degAngle>120)
          yShift=-eAxesValueFontSize/4;
          al=-1;
        end
        if (degAngle<=300) & (degAngle>240)
          yShift=-eAxesValueFontSize;
          al=0;
        end
        etext(valueText,pos3(1),pos3(2)+yShift,...
              eAxesValueFontSize,al,5,0,eAxesColor);
      end
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
      angle=angle+pieSliceSize;
    end %for
    ePieSliceNo=0;
  else    
    % add plot line
    ePieSliceNo=ePieSliceNo+1;

    %lineWidth
    width=eAxesLineWidth; 
    parameter=sprintf('global ePieSliceW%d;',ePieSliceNo);
    eval(parameter);
    parameter=sprintf('ePieSliceW%d=width;',ePieSliceNo);
    eval(parameter);

    %dash
    if (nargin<4)
      dash=ePlotLineDash; 
    end
    parameter=sprintf('global ePieSliceDash%d;',ePieSliceNo);
    eval(parameter);
    parameter=sprintf('ePieSliceDash%d=dash;',ePieSliceNo);
    eval(parameter);

    %color
    if (nargin<6)
      if dash>=0
        color=eAxesColor;
      else
        color=0.5+...
          [0.5*sin(ePieSliceNo*3) 0.4*cos(ePieSliceNo*2) -0.3*cos(ePieSliceNo)];
      end
    end
    parameter=sprintf('global ePieSliceC%d;',ePieSliceNo);
    eval(parameter);
    parameter=sprintf('ePieSliceC%d=color;',ePieSliceNo);
    eval(parameter);
    
    % legend text
    if (nargin<3)
      legendText='';
    end
    parameter=sprintf('global ePieSliceLegText%d;',ePieSliceNo);
    eval(parameter);
    parameter=sprintf('ePieSliceLegText%d=legendText;',ePieSliceNo);
    eval(parameter);
  
    % value
    parameter=sprintf('global ePieSliceValue%d;',ePieSliceNo);
    eval(parameter);
    parameter=sprintf('ePieSliceValue%d=value;',ePieSliceNo);
    eval(parameter);

    % valueText
    if (nargin<2)
      valueText='';
    end
    parameter=sprintf('global ePieSliceValueText%d;',ePieSliceNo);
    eval(parameter);
    parameter=sprintf('ePieSliceValueText%d=valueText;',ePieSliceNo);
    eval(parameter);
 
    % offset
    if (nargin<5)
      offset=0;
    end
    parameter=sprintf('global ePieSliceOffset%d;',ePieSliceNo);
    eval(parameter);
    parameter=sprintf('ePieSliceOffset%d=offset;',ePieSliceNo);
    eval(parameter);
   
    if ePieSliceNo==1
      ePolarPlotAreaValStart=value;
    else
      ePolarPlotAreaValStart=ePolarPlotAreaValStart+value;
    end
  end
