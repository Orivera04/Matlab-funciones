%%NAME
%%  eplot  - make linear plot
%%
%%SYNOPSIS
%%  eplot ([xData,[yData,[legendText,[dash,[color[,width]]]]]])
%%
%%PARAMETER(S)
%%  xData          vector of x-data  
%%                 or matrix(2xn) of x0,x1-data to plot lines 
%%  yData          vector of y-data
%%                 or matrix(2xn) of y0,y1-data to plot lines
%%  legendText     text of legend, if empty  string then no legend
%%  dash          if a scalar and
%%                  dash=0  solid plot line,
%%                  dash>0  dash length
%%                  dash<0  fill plot line with color
%%                default: dash=eLineDash
%%                if a vector with size 1xn, then dash describes
%%                  a dash combination [space lineLength1 lineLength2 ...]
%%                if a string then dash is a name of symbol
%%                if a matrix and color=-1
%%                  dash is the image of plot 
%%                  and filled with RGB values
%%                  (value=R*2^16+G*2^8+B and R,G,B are integer of 0:255)
%%                if a matrix and color is a colormap
%%                  dash is the image of plot 
%%                  and filled with indices of colormap
%%                if a string dash is filename of a JPEG-file
%%  color         if dash>=0 vector of plot color ([r g b])
%%                if dash<0  vector of background color
%%                if dash a matrix then colormap of image or -1
%%                default: dash=eLineColor
%%  width         width of plot line
%% 
%% Important: eplot without parameters closes the current plot explicit.
%%            it's useful for several plot on one page 
%%
%%GLOBAL PARAMETER(S)
%%  ePlotAreaPos
%%  ePlotAreaWidth
%%  ePlotAreaHeight
%%  eXAxisSouthScale
%%  eYAxisWestScale
%%  ePlotAreaXValueStart
%%  ePlotAreaXValueEnd
%%  ePlotAreaYValueStart
%%  ePlotAreaYValueEnd
%%  ePlotLineInterpolation
%%  ePlotLineWidth
%%  ePlotLineColor; 
%%  ePlotLineDash; 
%%  ePlotLegendPos;
%%  ePlotLegendTextFont
%%  ePlotLegendFontSize
%%  ePlotLegendDistance
%%  eAxesColor
% written by stefan.mueller@fgan.de (C) 2007

function eplot(xData,yData,legendText,dash,color,width)
  if nargin>6
    eusage('eplot([xData,[yData,[legendText,[dash,[color[,width]]]]]])');
  end
  eglobpar;
  if (nargin==0)
    %finish plotting
    
    % write title
    etitle;

    %value range
    if eXAxisSouthScale(1)~=eXAxisSouthScale(3)
      %fix scale
      ePlotAreaXValueStart=eXAxisSouthScale(1);
      ePlotAreaXValueEnd=eXAxisSouthScale(3);
    else
      if eXAxisSouthScaleType==2
        if (ePlotAreaXValueStart>0)&(ePlotAreaXValueEnd>0)
          ePlotAreaXValueStart=log10(ePlotAreaXValueStart);
          ePlotAreaXValueEnd=log10(ePlotAreaXValueEnd);
        else 
          error('xValues<=0 for log scale');
        end
      end
    end
    if eYAxisWestScale(1)~=eYAxisWestScale(3)
      %fix scale 
      ePlotAreaYValueStart=eYAxisWestScale(1);
      ePlotAreaYValueEnd=eYAxisWestScale(3);
    else
      if eYAxisWestScaleType==2
        if (ePlotAreaYValueStart>0)&(ePlotAreaYValueEnd>0)
          ePlotAreaYValueStart=log10(ePlotAreaYValueStart);
          ePlotAreaYValueEnd=log10(ePlotAreaYValueEnd);
        else 
          error('yValues<=0 for log scale');
        end
      end
    end
    if (eXAxisSouthScale(1)==eXAxisSouthScale(3))&eAxesCrossOrigin
      xRange=ePlotAreaXValueEnd-ePlotAreaXValueStart;
      ePlotAreaXValueStart=ePlotAreaXValueStart-0.05*xRange; 
      ePlotAreaXValueEnd=ePlotAreaXValueEnd+0.05*xRange; 
    end
    if eYAxisWestScale(1)==eYAxisWestScale(3)
      yRange=ePlotAreaYValueEnd-ePlotAreaYValueStart;
      ePlotAreaYValueStart=ePlotAreaYValueStart-0.05*yRange; 
      ePlotAreaYValueEnd=ePlotAreaYValueEnd+0.05*yRange; 
    end
    egrid;
      
    % plot line and write legend
    if ePlotAreaXValueEnd==ePlotAreaXValueStart
      ePlotAreaXValueStart=ePlotAreaXValueStart-1;
      ePlotAreaXValueEnd=ePlotAreaXValueEnd+1
    end
    if ePlotAreaYValueEnd==ePlotAreaYValueStart
      ePlotAreaYValueStart=ePlotAreaYValueStart-1;
      ePlotAreaYValueEnd=ePlotAreaYValueEnd+1
    end
    ePlotAreaXFac=ePlotAreaWidth*eFac/...
      (ePlotAreaXValueEnd-ePlotAreaXValueStart);
    ePlotAreaYFac=ePlotAreaHeight*eFac/...
      (ePlotAreaYValueEnd-ePlotAreaYValueStart);
    legendPos=ePlotLegendPos;
    for i=1:ePlotLineNo
      parameter=sprintf('global ePlotLineWidth%d;',i);
      eval(parameter);
      parameter=sprintf('width=ePlotLineWidth%d;',i);
      eval(parameter);
      parameter=sprintf('global ePlotLineColor%d;',i);
      eval(parameter);
      parameter=sprintf('color=ePlotLineColor%d;',i);
      eval(parameter);
      parameter=sprintf('global ePlotLineDash%d;',i);
      eval(parameter);
      parameter=sprintf('dash=ePlotLineDash%d;',i);
      eval(parameter);
      parameter=sprintf('global ePlotLegendText%d;',i);
      eval(parameter);
      parameter=sprintf('legendText=ePlotLegendText%d;',i);
      eval(parameter);
      parameter=sprintf('global ePlotXData%d;',i);
      eval(parameter);
      parameter=sprintf('xData=ePlotXData%d;',i);
      eval(parameter);
      parameter=sprintf('global ePlotYData%d;',i);
      eval(parameter);
      parameter=sprintf('yData=ePlotYData%d;',i);
      eval(parameter);
      if eXAxisSouthScaleType==2
        xData=log10(xData);
      end
      xData=(xData-ePlotAreaXValueStart)*ePlotAreaXFac;
      [xr xc]=size(xData);
      if eYAxisWestScaleType==2
        yData=log10(yData);
      end
      yData=(yData-ePlotAreaYValueStart)*ePlotAreaYFac;
      [yr yc]=size(yData);

      eclip(eFile,ePlotAreaPos(1)*eFac,ePlotAreaPos(2)*eFac,...
            ePlotAreaWidth*eFac,ePlotAreaHeight*eFac);   
      if isstr(dash)
        n=size(xData,2);
        exyplots(eFile,...
          ePlotAreaPos(1)*eFac,...
          ePlotAreaPos(2)*eFac,...
          xData(1,:),...
          yData(1,:),...
          ones(1,n),...
          ones(1,n),...
          zeros(1,n),...
          dash,...
          color);
      elseif (size(dash,1)>1) && (size(dash,2)>1) 
        exyploti(eFile,...
          ePlotAreaPos(1)*eFac,...
          ePlotAreaPos(2)*eFac,...
          xData(1,:),...
          yData(1,:),...
          dash,...
          color);
      elseif (dash<0)
        exyplotf(eFile,...
          ePlotAreaPos(1)*eFac,...
          ePlotAreaPos(2)*eFac,...
          xData(1,:),...
          yData(1,:),...
          color,...
	  ePlotLineInterpolation)
      elseif xr==1
        exyplot(eFile,...
          ePlotAreaPos(1)*eFac,...
          ePlotAreaPos(2)*eFac,...
          xData(1,:),...
          yData(1,:),...
          color,...
          dash*eFac,...
          width*eFac,...
	  ePlotLineInterpolation);
      else
        xData=reshape(xData,1,2*xc); 
        yData=reshape(yData,1,2*yc); 
        exyline(eFile,...
          ePlotAreaPos(1)*eFac,...
          ePlotAreaPos(2)*eFac,...
          xData,...
          yData,...
          color,...
          dash*eFac,...
          width*eFac);
      end
      eclip(eFile,0,0,0,0);
      if strcmp(legendText,'')~=1
        eplotlg(eFile,...
          (ePlotAreaPos(1)+legendPos(1))*eFac,...
          (ePlotAreaPos(2)+legendPos(2))*eFac,...
          color,... 
          dash,...
          width*eFac,...
          legendText,...
          eFonts(ePlotLegendTextFont,:),...
          ePlotLegendFontSize*eFac,eAxesColor);
        legendPos(2)=legendPos(2)-ePlotLegendDistance/70*ePlotLegendFontSize;
      end
    end
    eaxes;
    ePlotLineNo=0;
  else    
    % add plot line
    ePlotLineNo=ePlotLineNo+1;
    %width
    if (nargin<6) 
      width=ePlotLineWidth;
    end
    parameter=sprintf('global ePlotLineWidth%d;',ePlotLineNo);
    eval(parameter);
    parameter=sprintf('ePlotLineWidth%d=width;',ePlotLineNo);
    eval(parameter);
    %color
    if (nargin<5)
      color=ePlotLineColor; 
    end
    parameter=sprintf('global ePlotLineColor%d;',ePlotLineNo);
    eval(parameter);
    parameter=sprintf('ePlotLineColor%d=color;',ePlotLineNo);
    eval(parameter);
    
    %dash
    if (nargin<4)
      dash=ePlotLineDash; 
    end
    parameter=sprintf('global ePlotLineDash%d;',ePlotLineNo);
    eval(parameter);
    parameter=sprintf('ePlotLineDash%d=dash;',ePlotLineNo);
    eval(parameter);
  
    % legend text
    if (nargin<3)
      legendText='';
    end
    parameter=sprintf('global ePlotLegendText%d;',ePlotLineNo);
    eval(parameter);
    parameter=sprintf('ePlotLegendText%d=legendText;',ePlotLineNo);
    eval(parameter);

    [xr xc]=size(xData);
    if xr>2
      xData=xData';
    end
    if (nargin<2)
      yData=xData;
      xData=1:size(yData,2);
      if xr==2
        xData=[xData;xData];
      end
    else
      [yr yc]=size(yData);
      if yr>2
       yData=yData';
      end
    end
    % data
    parameter=sprintf('global ePlotXData%d;',ePlotLineNo);
    eval(parameter);
    parameter=sprintf('ePlotXData%d=xData;',ePlotLineNo);
    eval(parameter);
    parameter=sprintf('global ePlotYData%d;',ePlotLineNo);
    eval(parameter);
    parameter=sprintf('ePlotYData%d=yData;',ePlotLineNo);
    eval(parameter);
  
    %value range
    xMin=min(min(xData));
    xMax=max(max(xData));
    if xMin<ePlotAreaXValueStart | ePlotLineNo==1
      ePlotAreaXValueStart=xMin;
    end
    if xMax>ePlotAreaXValueEnd | ePlotLineNo==1
      ePlotAreaXValueEnd=xMax;
    end
    yMin=min(min(yData));
    yMax=max(max(yData));
    if yMin<ePlotAreaYValueStart | ePlotLineNo==1
      ePlotAreaYValueStart=yMin;
    end
    if yMax>ePlotAreaYValueEnd | ePlotLineNo==1
      ePlotAreaYValueEnd=yMax;
    end
  end
