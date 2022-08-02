%%NAME
%%  ejpg2eps  - converts JPEG-file to EPS-file
%%
%%SYNOPSIS
%%  dpi=ejpg2eps(jpgFileName[,epsFileName])
%%
%%PARAMETER(S)
%%  jpgFileName          JPEG-filenames 
%%  epsFileName          EPS-filenames 
%%  dpi                  resolution (dots per inch) 
%%
% written by stefan.mueller@fgan.de (C) 2007
function dpi=ejpg2eps(jpgFileName,epsFileName)
  if nargin>2 
    eusage('dpi=ejpg2eps(jpgFileName[,epsFileName])');
  end
  eglobpar;
  if exist('eFac')
    if isempty(eFac)
      einit;
    end
  else
    einit;
  end
  if nargin<1
    jpgFileName=[ePath 'default.jpg'];
  end
  if nargin<2
    epsFileName=jpgFileName;
    suffixPos=findstr(epsFileName,'.jpg');
    epsFileName(suffixPos(1):suffixPos(1)+3)='.eps';
  end
 [image head]=ejpgread(jpgFileName);
 jpgH=head(2); 
 jpgW=head(3); 
 winFac=eWinHeight/eWinWidth;
 imgFac=jpgH/jpgW;
 if winFac<imgFac
   eWinWidth=eWinHeight/imgFac;
   dpi=jpgH*72/eWinHeight/eFac;
 else
   eWinHeight=eWinWidth*imgFac;
   dpi=jpgW*72/eWinWidth/eFac;
 end
 offsetX=1.2*eWinWidth/jpgW;
 offsetY=1.2*eWinHeight/jpgH;
 esavpar2
 eopen(epsFileName,0,eWinWidth,eWinHeight)
 eframe(0,0,eWinWidth+offsetX,eWinHeight+offsetY,0,image,head);
 eclose(1,0);
 erespar2
