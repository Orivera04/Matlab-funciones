%%NAME
%%  equiver - draw a quiver plot of matrix
%%
%%SYNOPSIS
%%  equiver(xData,yData,dx,dy[,color[,symbolName]])
%%
%%PARAMETER(S)
%%  xData           vector or matrix of x-positions of the symbols
%%  yData           vector or matrix of y-positions of the symbols
%%  dx              vector or matrix of x-values to determine
%%                  the direction and relative magnitude of the symbols
%%  dy              vector or matrix of y-values to determine
%%                  the direction and relative magnitude of the symbols
%%  color           color of symbols, vector [r g b]
%%  symbolName      symbol name of edsymbol() function
%%                  default symbol is an arrow 
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
% written by stefan.mueller@fgan.de (C) 2007

function equiver(xData,yData,dx,dy,color,symbolName)
  if nargin>6 | nargin<4
    eusage('equiver(xData,yData,dx,dy[,color[,symbolName]])');
  end
  eglobpar;
  if nargin<6
    symbolName='vector';
    edsymbol(symbolName,'farrow.psd');
  end
  if nargin<5
    color=[0 0 0];
  end
  [rows cols]=size(xData);
  if cols>1
    xData=reshape(xData,1,rows*cols);
    yData=reshape(yData,1,rows*cols);
    dx=reshape(dx,1,rows*cols);
    dy=reshape(dy,1,rows*cols);
  end
  rad2deg=180/pi;
  dx2=dx.*dx;
  dy2=dy.*dy;
  angle=dx;
  vDiff=dy2-dx2;
  xgy=find(vDiff<0);
  angle(xgy)=atan(dy(xgy)./dx(xgy))*rad2deg;
  sCase=find(dx(xgy)<0);
  angle(xgy(sCase))=angle(xgy(sCase))+180;
  ygx=find(vDiff>=0);
  angle(ygx)=90-atan(dx(ygx)./dy(ygx))*rad2deg;
  sCase=find(dy(ygx)<0);
  angle(ygx(sCase))=angle(ygx(sCase))+180;
  vectorLength=sqrt(dx2+dy2);
  maxL=max(vectorLength);
  n=length(xData);
  deltaX=xData(1:n-1)-xData(2:n);
  deltaX=deltaX(find(deltaX));
  deltaX=deltaX.*deltaX;
  deltaX=sqrt(min(deltaX));
  deltaY=yData(1:n-1)-yData(2:n);
  deltaY=deltaY(find(deltaY));
  deltaY=deltaY.*deltaY;
  deltaY=sqrt(min(deltaY));
  deltaMin=min([deltaX deltaY]);
  if maxL>deltaMin
    vectorLength=vectorLength/maxL*deltaMin;
    maxL=deltaMin;
  end
   

 %value range
  if eXAxisSouthScale(1)==eXAxisSouthScale(3)
    ePlotAreaXValueStart=min(xData);
    ePlotAreaXValueEnd=max(xData);
    ePlotAreaXValueStart=ePlotAreaXValueStart-maxL;
    ePlotAreaXValueEnd=ePlotAreaXValueEnd+maxL;
  else
    %fix scale
    ePlotAreaXValueStart=eXAxisSouthScale(1);
    ePlotAreaXValueEnd=eXAxisSouthScale(3);
  end
  if eYAxisWestScale(1)==eYAxisWestScale(3)
    ePlotAreaYValueStart=min(yData);
    ePlotAreaYValueEnd=max(yData);
    ePlotAreaYValueStart=ePlotAreaYValueStart-maxL;
    ePlotAreaYValueEnd=ePlotAreaYValueEnd+maxL;
  else
    %fix scale
    ePlotAreaYValueStart=eYAxisWestScale(1);
    ePlotAreaYValueEnd=eYAxisWestScale(3);
  end                                          
  ePlotAreaXFac=ePlotAreaWidth*eFac/...
    (ePlotAreaXValueEnd-ePlotAreaXValueStart);
  ePlotAreaYFac=ePlotAreaHeight*eFac/...
    (ePlotAreaYValueEnd-ePlotAreaYValueStart);        
  xData=(xData-ePlotAreaXValueStart)*ePlotAreaXFac;
  yData=(yData-ePlotAreaYValueStart)*ePlotAreaYFac;           

  exyplots(eFile,...
          ePlotAreaPos(1)*eFac,...
          ePlotAreaPos(2)*eFac,...
          xData(1,:),...
          yData(1,:),...
          vectorLength*ePlotAreaXFac/28.35,...
          vectorLength*ePlotAreaYFac/28.35,...
          angle,...
          symbolName,...
          color);                     

  egrid;
  eaxes;
