%ehead(epsFile,winWidth,winHeight,pageWidth,pageHeight,pageOrientation,xScaleFac,yScaleFac,xOffset,yOffset)
% this function write postscript commands in  epsFile to initialize
% the eps-output  
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function ehead(epsFile,winWidth,winHeight,pageWidth,pageHeight,pageOrientation,xScaleFac,yScaleFac,xOffset,yOffset,pageReflection)
  if (nargin~=11)
    eusage('ehead(epsFile,winWidth,winHeight,pageWidth,pageHeight,pageOrientation,xScaleFac,yScaleFac,xOffset,yOffset)');
  end

  % win size 
  if pageOrientation==1 | pageOrientation==3
    winW=winWidth;
    winWidth=winHeight; 
    winHeight=winW; 
  end
  winWidth=winWidth*xScaleFac;
  winHeight=winHeight*yScaleFac;

  % max plot area
  printerFrame=17;
  pageHeight=pageHeight-2*printerFrame;
  pageWidth=pageWidth-2*printerFrame;

  % scale factor
  if winWidth/pageWidth>winHeight/pageHeight
    maxFac=pageWidth/winWidth;
  else 
    maxFac=pageHeight/winHeight;
  end
  if maxFac<1
    disp('Graphic reduced !');
    winHeight=winHeight*maxFac;
    winWidth=winWidth*maxFac;
  else
    maxFac=1;
  end
  xScaleFac=xScaleFac*maxFac;
  yScaleFac=yScaleFac*maxFac;

  % win offset
  winX0=(pageWidth-winWidth)/2+printerFrame+xOffset;
  winY0=(pageHeight-winHeight)/2+printerFrame+yOffset;

  % new origin
  if pageOrientation==0
    originX=winX0;
    originY=winY0;
    reflectShift=winWidth;
  elseif pageOrientation==1
    originX=winY0;
    originY=-(winX0+winWidth);
    reflectShift=winHeight;
  elseif pageOrientation==2
    originX=-(winX0+winWidth);
    originY=-(winY0+winHeight);
    reflectShift=winWidth;
  else
    originX=-(winY0+winHeight);
    originY=winX0;
    reflectShift=winHeight;
  end

  % write eps head 
  fprintf(epsFile,'%%!PS-Adobe-2.0 EPSF-2.0\n');
  fprintf(epsFile,'%%%%Creator: epsTk 2.0 stefan.mueller@fgan.de 2003\n');
  timeStamp=clock;
  min1=fix(timeStamp(5)/10);
  min2=rem(timeStamp(5),10);
  fprintf(epsFile,'%%%%Time: %d.%d.%d %d:%d%d:%d\n',...
                 timeStamp(3),timeStamp(2),timeStamp(1),...
                 timeStamp(4),min1,min2,timeStamp(6));
  fprintf(epsFile,'%%%%BoundingBox: %d %d %d %d\n',...
          fix(winX0),fix(winY0),fix(winX0+winWidth),fix(winY0+winHeight));
  fprintf(epsFile,'%%%%EndComments\n');
  fprintf(epsFile,'%1.2f rotate\n',pageOrientation*90);
  fprintf(epsFile,'%d %d translate\n',fix(originX),fix(originY));
  if pageReflection==1
    fprintf(epsFile,'%1.2f 0 translate\n',reflectShift);
    fprintf(epsFile,'-1 1 scale\n');
  end
  fprintf(epsFile,'%1.2f %1.2f scale\n',xScaleFac,yScaleFac);
  fprintf(epsFile,'/GermanExtension[\n');
  fprintf(epsFile,'8#374 /udieresis\n');
  fprintf(epsFile,'8#334 /Udieresis\n');
  fprintf(epsFile,'8#344 /adieresis\n');
  fprintf(epsFile,'8#304 /Adieresis\n');
  fprintf(epsFile,'8#366 /odieresis\n');
  fprintf(epsFile,'8#326 /Odieresis\n');
  fprintf(epsFile,'8#337 /germandbls\n');
  fprintf(epsFile,']def\n');
  fprintf(epsFile,'/ReEncode {\n');
  fprintf(epsFile,'/newFontName exch def\n');
  fprintf(epsFile,'/oldFontName exch def\n');
  fprintf(epsFile,'/basefontdict oldFontName findfont def\n');
  fprintf(epsFile,'/nFont basefontdict maxlength dict def\n');
  fprintf(epsFile,'basefontdict{exch dup /FID ne {dup /Encoding eq\n');
  fprintf(epsFile,'{exch dup length array copy nFont 3 1 roll put}\n');
  fprintf(epsFile,'{exch nFont 3 1 roll put}ifelse}{pop pop} ifelse}forall\n');
  fprintf(epsFile,'nFont /FontName newFontName put\n');
  fprintf(epsFile,'GermanExtension aload pop GermanExtension length 2 idiv\n');
  fprintf(epsFile,'{nFont /Encoding get 3 1 roll put} repeat\n');
  fprintf(epsFile,'newFontName nFont definefont pop }def\n');
