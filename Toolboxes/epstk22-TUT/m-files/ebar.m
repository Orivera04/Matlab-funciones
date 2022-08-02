%%NAME
%%  ebar - get coordinates for bar-plotting
%%
%%SYNOPSIS
%%  [xb yb]=ebar(y[,barWidth[,barNumber,clusterSize,[,x]])
%%
%%PARAMETER(S)
%%  
%%  y            vector of y-data
%%  barWidth     x-size of bars
%%               if barWidth=0 then autosize
%%               default: barWidth=0
%%  number       number whithin the cluster
%%  clusterSize  total number of bars in one cluster 
%%  x            vector of x-data
%%
%%  xb           vector of x-coodinates
%%  yb           vector of y-coodinates
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function [xb,yb]=ebar(y,barWidth,barNumber,clusterSize,x)
  eglobpar
  if nargin>5 | nargin<1 | nargin==3
    eusage('[xb yb]=ebar(y[,barWidth[,barNumber,clusterSize[,x]])');
  end
  n=length(y);
  m=1:n;
  if nargin<5
    x=m;
  end
  if nargin<4
    barNumber=1;
    clusterSize=1;
  end
  xDiff=x(2:n)-x(1:n-1);
  minDeltaX=min(xDiff);
  if nargin<2 | barWidth==0
    barWidth=0.7*minDeltaX/clusterSize;
  end
  barWidth=barWidth/2;
  
  i=1:4:4*n;
  yb=zeros(4*n,1);
  yb(i(m)+1)=y(m);
  yb(i(m)+2)=y(m);

  xb=zeros(4*n,1);
  xb(i(m))=x(m)-barWidth;
  xb(i(m)+1)=x(m)-barWidth;
  xb(i(m)+2)=x(m)+barWidth;
  xb(i(m)+3)=x(m)+barWidth;

  xb=xb+(barNumber*2-1-clusterSize)*barWidth;
  if eXAxisSouthScaleType
    xb=xb-minDeltaX/2;
  end
