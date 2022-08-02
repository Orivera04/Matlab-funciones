%%NAME
%%  eopen  - open EPS-file, define size of page, size of window and
%%           call 'einit' to initialize the global parameter
%%
%%SYNOPSIS
%%  eopen([ epsFileName[,pageOrientation[,winWidth,winHeight
%%        [,winShift[,xScaleFac,yScaleFac[,pageWidth,pageHeight
%%        [,pageReflection]]]]]]])
%%
%%PARAMETER(S)
%%  epsFileName       name of eps-file (default name is defined as eFileName)
%%  pageOrientation   page orientation,
%%                    0=portrait 1=landscape 2=upside-down 3=seaside
%%  winWidth          width of window(=eps bounding-box)
%%  winHeight         height of window(=eps bounding-box)
%%  winShift          shift-vector of window, [xOffset yOffset]
%%                    ,shift of window center on page,
%%                    default vector is [0 0]=middle of page
%%  xScaleFac         scale factor 1= no resize   
%%  yScaleFac         scale factor 1= no resize   
%%  pageWidth         width of page
%%  pageHeight        height of page
%%  pageReflection    refection 1=on 0=off
%% 
%%GLOBAL PARAMETER(S)
%%  eFileName
%%  ePageWidth
%%  ePageHeight
%%  ePageScaleFac
%%  ePageOrientation
%%  ePageReflection
%%  eUserUnit
%%  eWinWidth
%%  eWinHeight
%%  eFonts
% written by stefan.mueller@fgan.de (C) 2007

function eopen(epsFileName,pageOrientation,winWidth,winHeight,winShift,xScaleFac,yScaleFac,pageWidth,pageHeight,pageReflection)
  if nargin>10 | nargin==3 | nargin==6 | nargin==8
    eusage('eopen([epsFileName[,pageOrientation,[winWidth,winHeight[,winShift[,xScaleFac,yScaleFac[,pageWidth,pageHeight]]]]] )');
  end
  eglobpar;
  einit;
  ePlotLineNo=0;
  ePolarPlotLineNo=0;
  ePieSliceNo=0;
  if nargin>0
    eFileName=epsFileName;
  end
  if nargin>1
    ePageOrientation=pageOrientation;
  end
  if nargin==2 & rem(ePageOrientation,2)
    winW=eWinWidth;
    eWinWidth=eWinHeight;
    eWinHeight=winW;
  end
  if nargin>3
    eWinWidth=winWidth;
    eWinHeight=winHeight;
  end
  if nargin<5
    winShift=[0 0];
  end
  if nargin>5
    eXScaleFac=xScaleFac;
    eYScaleFac=yScaleFac;
  end
  if nargin>7
    ePageWidth=pageWidth;
    ePageHeight=pageHeight;
  end
  if nargin>9
    ePageReflection=pageReflection;
  end
  
  % open eps file
  eFile=fopen(eFileName,'wb');
  if eFile<0
    errortext=sprintf('error in eopen: can not open %s',eFileName);
    disp(errortext);
  else 
    % write eps head
    ehead(eFile,eWinWidth*eFac,eWinHeight*eFac,...
          ePageWidth*eFac,ePageHeight*eFac,...
          ePageOrientation,eXScaleFac,eYScaleFac,...
          winShift(1)*eFac,winShift(2)*eFac,ePageReflection);
  
    % reencode fonts
    newFonts=erencode(eFile,eFonts(1,:));
    for i=2:size(eFonts,1)
      newFonts=[newFonts;erencode(eFile,eFonts(i,:))];
    end
    eFonts=newFonts;
  end
