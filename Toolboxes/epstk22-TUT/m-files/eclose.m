%%NAME
%%  eclose - finish plot(s) and close EPS-file 
%%
%%SYNOPSIS
%%  eclose ([nCopies[,message]])
%%
%%PARAMETER(S)
%%  nCopies     number of hardcopies, for printing 1 or more copies
%%              default: nCopies=1, print one copy of current page
%%              if nCopies=0 then 'showpage' will not append
%%  message     switch for 'file written' message 
%%              if message=1 then write message (default)
%%              else no message
%%
%%GLOBAL PARAMETER(S)
%%  eWinFrameVisible
%%  eWinTimeStampVisible
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function eclose(nCopies,message)
  eglobpar;
  if nargin>2
    eusage('eclose([nCopies[,message]])');
  end
  if nargin<2
    message=1;
  end
  if nargin<1
    nCopies=1;
  end
  if ePlotLineNo>0
    eplot
    ePlotLineNo=0;
  end
  if ePolarPlotLineNo>0
    epolar
    ePolarPlotLineNo=0;
  end
  if ePieSliceNo>0
    epie
    ePieSliceNo=0;
  end
  if eWinTimeStampVisible
    timeStamp=clock;
    min1=fix(timeStamp(5)/10);
    min2=rem(timeStamp(5),10);
    timeStampText=sprintf('epsTk 2.0 %d.%d.%d %d:%d%d:%d File:%s',...
                          timeStamp(3),timeStamp(2),timeStamp(1),...
                          timeStamp(4),min1,min2,timeStamp(6),...
                          eFileName);
    etext(timeStampText,-1,0,eWinTimeStampFontSize,1,...
         eWinTimeStampFont,90);
  end
  if eWinFrameVisible
    erect(eFile,0,0,eWinWidth*eFac,eWinHeight*eFac,...
          eWinFrameLineWidth,[0 0 0],0,0);
  end
  if eWinGridVisible
    esavpar;
    ePlotAreaPos=[0 0];
    ePlotAreaHeight=eWinHeight;
    ePlotAreaWidth=eWinWidth;
    eXGridVisible=1;
    eYGridVisible=1;
    eXGridColor=[0.6 0.6 0.6];
    eYGridColor=[0.6 0.6 0.6];
    eaxes([0 10 eWinWidth],[0 10 eWinHeight]);
    egrid;
    erespar;
  end
  if nCopies>0
    fprintf(eFile,'/#copies %d def\n',nCopies);
    fprintf(eFile,'showpage\n');
  end
  fclose(eFile);
  eFile=-1;
  if message==1
    if nCopies>1
      message=sprintf('%s (hardcopies:%d) is written',eFileName,nCopies);
    else
      message=sprintf('%s is written',eFileName);
    end
    disp(message);
  end
  if exist('close')
    close
  end
