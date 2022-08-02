%%NAME
%%  econtour - draw a contour plot of matrix
%%
%%SYNOPSIS
%%  econtour(matrix[,scale[,dash[,colorMap]]])
%%
%%PARAMETER(S)
%%  matrix     matrix for contour plot 
%%  scale      vector of scaling [start step end]
%%  dash       if dash=0 then draw solid lines
%%             else value of dash is the distance of dashs 
%%  colorMap   colors for different iso-lines
%% 
%%GLOBAL PARAMETER(S)
%%  ePlotAreaWidth
%%  ePlotAreaHeight
%%  ePlotAreaPos
%%  eContourLineColor
%%  eContourLineDash
%%  eContourScale
%%  eContourLevelsMaxN
%%  eContourValueFormat
%%  eContourLineWidth
%%  eContourValueVisible
%%  eContourValueDistance
%%  eContourValueFont
%%  eContourValueFontSize
%%  eYAxisWestScale
%%  eXAxisSouthScale
%% 
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function econtour(matrix,scale,dash,colorMap)
  if nargin>4 
    eusage('econtour(matrix[,scale[,dash[,colorMap]]])');
  end
  eglobpar;
  if nargin<4
    colorMap=eContourLineColor;
  end
  if nargin<3
    dash=eContourLineDash;
  end
  if nargin<2
    scale=eContourScale;
  end
  if nargin<1
    x=-2:.1:2;
    y=-2:.1:2;
    [X,Y]=meshgrid(x,y);
    matrix=X.*exp(-X.^2-Y.^2);
  end

  %scaling
  [ rows cols ] = size (matrix);
  maxval = max (max (matrix));
  minval = min (min (matrix));
  if scale(1)==scale(3)
    scale(1)=minval;
    scale(3)=maxval;
  end
  startEndDiff=scale(3)-scale(1);
  if scale(2)==0
    %autoscale
    signOfDelta=sign(startEndDiff);
    delta=eticdis(signOfDelta*startEndDiff,eContourLevelsMaxN);
    offset=rem(scale(1),delta)*signOfDelta;
    if offset<0
      offset=delta+offset;
    end
    firstValue=scale(1)+delta*signOfDelta-offset;
  else 
    %fixscale
    signOfDelta=sign(scale(2));
    delta=signOfDelta*scale(2);
    firstValue=scale(1);
  end

  %value format
  vForm=eContourValueFormat;
  if vForm==0
    expo=-log10(delta);
    if rem(expo,1)>0
      expo=expo+1;
    end
    autoForm=fix(expo);
    if autoForm>0
      vForm=autoForm;
    end
  end
  if vForm<0
    valueForm='%g';
  else
    valueForm=sprintf('%%1.%df',vForm);
  end


  %isolines loop
  eclip(eFile,ePlotAreaPos(1)*eFac,ePlotAreaPos(2)*eFac,...
        ePlotAreaWidth*eFac,ePlotAreaHeight*eFac);
  isoValues=firstValue:delta*signOfDelta:scale(3);
  ncolor=size(colorMap,1);
  colorFac=(ncolor-1)/(maxval-minval);
  for i=1:length(isoValues)
    xy=eisoline(matrix,isoValues(i));
    if size(xy,1)>1
      ePlotAreaXFac=ePlotAreaWidth*eFac/cols;
      ePlotAreaYFac=ePlotAreaHeight*eFac/rows;
      xy(:,1)=xy(:,1)*ePlotAreaXFac;
      xy(:,2)=xy(:,2)*ePlotAreaYFac;
      color=colorMap(1+fix((isoValues(i)-minval)*colorFac),:);
      %draw isolines
      exyline(eFile,...
            ePlotAreaPos(1)*eFac,...
            ePlotAreaPos(2)*eFac,...
            xy(:,1),xy(:,2),color,...
            dash*eFac,eContourLineWidth*eFac);
      % write values
      if eContourValueVisible==1
        [maxv maxi]=max(xy(:,2));
        if rem(maxi,2)==1
          txy1=xy(maxi,:);
          txy2=xy(maxi+1,:);
        else
          txy1=xy(maxi-1,:);
          txy2=xy(maxi,:);
        end
        xdiff=txy2(1)-txy1(1);
        ydiff=txy2(2)-txy1(2);
        if xdiff>eps
          angle=atan(ydiff/xdiff)/pi*180;
        else
          angle=90;
        end
        if abs(isoValues(i))<1e-14
          isoValues(i)=0;
        end
        valueStr=sprintf(valueForm,isoValues(i));
        distance=1*eFac;
        textx=ePlotAreaPos(1)*eFac+txy1(1)+xdiff/2-...
              sin(angle/180*pi)*eContourValueDistance;
        texty=ePlotAreaPos(2)*eFac+txy1(2)+ydiff/2+...
              cos(angle/180*pi)*eContourValueDistance;
        etextxy(eFile,textx,texty,angle,0,valueStr,...
                eFonts(eContourValueFont,:),eContourValueFontSize*eFac,color);
      end
    end
  end
  eclip(eFile,0,0,0,0);

  if eYAxisWestScale(1)==eYAxisWestScale(3)
    eYAxisWestScale=[0 0 rows];
  end
  if eXAxisSouthScale(1)==eXAxisSouthScale(3)
    eXAxisSouthScale=[0 0 cols];
  end
  etitle;
  egrid;
  eaxes;
