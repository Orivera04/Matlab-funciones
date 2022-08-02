%%NAME
%%  eimgmask  - create few masks for image processing 
%%
%%SYNOPSIS
%%  imageMask=eimgmask(nRows,nCols[,maskType,[maskPara]])
%%
%%PARAMETER(S)
%%  nRows       number of rows
%%  nCols       number of colums
%%  maskType    type of mask
%%              1: rotation mask, default mask
%%              2: linear mask
%%              3: random mask
%%  maskPara     
%%              if maskType==1 then it's radius of maximum, default=1
%%              if maskType==2 then
%%                 it's direction in deg ,default=-1
%%                   maskTyp<0: maximum in center
%%                   [0,45)   : from N(orth to S(outh)
%%                   [45,90)  : from NE to SW
%%                   [90,135) : from E to W
%%                   [135,180): from SE to NW
%%                   [180,225): from S to N
%%                   [225,270): from SW to NE
%%                   [270,315): from W to E
%%                   [315,360): from NW to SE 
%%                   maskType>=360    : minimum in center
%%              if maskType==3 then
%%                 it's maximum of values, default=1
%%                 
%%  imageMask   matrix of nRows x nCols with values between 0 and 1 
%% 
% written by stefan.mueller@fgan.de (C) 2007
function imageMask=eimgmask(nRows,nCols,maskType,maskPara)
  if nargin<2
    eusage('imageMask = eimgmask(nRows,nCols[,maskType[,maskPara]])');
  end
  if nargin<3
    maskType=1; 
  end
  if maskType==1
    if nargin<4
      maskPara=1;
    end
    delta=2*pi/(nCols-1);x=-pi:delta:pi;
    delta=2*pi/(nRows-1);y=-pi:delta:pi;
    [a b]=meshgrid(x,y);
    R=sqrt(a.^2+b.^2) + eps;
    imageMask=(sin(R)./R)*maskPara;
    imageMask(find(imageMask<0))=0;
    imageMask(find(imageMask>1))=1;
  end
  if maskType==2
    if nargin<4
      maskPara=-1;
    end
    if maskPara<0
      zValues=[0 0 0 0 1 0 0 0 0];
    elseif maskPara<45
      zValues=[0 0 0 0.5 0.5 0.5 1 1 1]; %s
    elseif maskPara<90
      zValues=[0.5 0.25 0 0.75 0.5 0.25 1 0.75 0.5]; %
    elseif maskPara<135
      zValues=[1 0.5 0 1 0.5 0 1 0.5 0];
    elseif maskPara<180
      zValues=[1 0.75 0.5 0.75 0.5 0.25 0.5 0.25 0];
    elseif maskPara<225
      zValues=[1 1 1 0.5 0.5 0.5 0 0 0];
    elseif maskPara<270
      zValues=[0.5 0.75 1 0.25 0.5 0.75 0 0.25 0.5];
    elseif maskPara<315
      zValues=[0 0.5 1 0 0.5 1 0 0.5 1];
    elseif maskPara<360
      zValues=[0 0.25 0.5 0.25 0.5 0.75 0.5 0.75 1];
    else
      zValues=[1 1 1 1 0 1 1 1 1];
    end
    xValues=[-1 0 1 -1 0 1 -1 0 1];
    yValues=[1 1 1 0 0 0 -1 -1 -1];

    deltaX=2/(nCols-1);
    deltaY=2/(nRows-1);
    imageMask=efillmat(xValues,yValues,zValues,deltaX,deltaY);
    imageMask=imageMask(1:nRows,1:nCols);
  end
  if maskType==3
    if nargin<4
      maskPara=1;
    elseif  maskPara<0 || maskPara>1
      maskPara=1;
    end
    imageMask=rand(nRows,nCols)*maskPara;
  end

