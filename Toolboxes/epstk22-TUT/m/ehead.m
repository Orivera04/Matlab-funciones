%ehead(epsFile,winWidth,winHeight,pageWidth,pageHeight,pageOrientation,xScaleFac,yScaleFac,xOffset,yOffset)
% this function write postscript commands in  epsFile to initialize
% the eps-output  
% written by stefan.mueller@fgan.de (C) 2007
% modified according to the TeX way, 2006/08/01 Nicolas Korber

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
  fprintf(epsFile,'%%%%Creator: epsTk2.2 stefan.mueller@fgan.de 2007\n');
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
  fprintf(epsFile,'8#001 /dotaccent 8#002 /fi 8#003 /fl\n');
  fprintf(epsFile,'8#004 /fraction 8#005 /hungarumlaut 8#006 /Lslash 8#007 /lslash\n');
  fprintf(epsFile,'8#010 /ogonek 8#011 /ring 8#013 /breve\n');
  fprintf(epsFile,'8#014 /minus 8#016 /Zcaron 8#017 /zcaron\n');
  fprintf(epsFile,'%% 0x10\n');
  fprintf(epsFile,'8#020 /caron 8#021 /dotlessi 8#022 /dotlessj 8#023 /ff\n');
  fprintf(epsFile,'8#024 /ffi 8#025 /ffl 8#026 /notequal 8#027 /infinity\n');
  fprintf(epsFile,'8#030 /lessequal 8#031 /greaterequal 8#032 /partialdiff 8#033 /summation\n');
  fprintf(epsFile,'8#034 /product 8#035 /pi 8#036 /grave 8#037 /quotesingle\n');
  fprintf(epsFile,'%% 0x80\n');
  fprintf(epsFile,'8#200 /Euro 8#201 /integral 8#202 /quotesinglbase 8#203 /florin\n');
  fprintf(epsFile,'8#204 /quotedblbase 8#205 /ellipsis 8#206 /dagger 8#207 /daggerdbl\n');
  fprintf(epsFile,'8#210 /circumflex 8#211 /perthousand 8#212 /Scaron 8#213 /guilsinglleft\n');
  fprintf(epsFile,'8#214 /OE 8#215 /Omega 8#216 /radical 8#217 /approxequal\n');
  fprintf(epsFile,'%% 0x90\n');
  fprintf(epsFile,'8#223 /quotedblleft\n');
  fprintf(epsFile,'8#224 /quotedblright 8#225 /bullet 8#226 /endash 8#227 /emdash\n');
  fprintf(epsFile,'8#230 /tilde 8#231 /trademark 8#232 /scaron 8#233 /guilsinglright\n');
  fprintf(epsFile,'8#234 /oe 8#235 /Delta 8#236 /lozenge 8#237 /Ydieresis\n');
  fprintf(epsFile,'%% 0xA0\n');
  fprintf(epsFile,'8#241 /exclamdown 8#242 /cent 8#243 /sterling\n');
  fprintf(epsFile,'8#244 /currency 8#245 /yen 8#246 /brokenbar 8#247 /section\n');
  fprintf(epsFile,'8#250 /dieresis 8#251 /copyright 8#252 /ordfeminine 8#253 /guillemotleft\n');
  fprintf(epsFile,'8#254 /logicalnot 8#255 /hyphen 8#256 /registered 8#257 /macron\n');
  fprintf(epsFile,'%% 0xD0\n');
  fprintf(epsFile,'8#260 /degree 8#261 /plusminus 8#262 /twosuperior 8#263 /threesuperior\n');
  fprintf(epsFile,'8#264 /acute 8#265 /mu 8#266 /paragraph 8#267 /periodcentered\n');
  fprintf(epsFile,'8#270 /cedilla 8#271 /onesuperior 8#272 /ordmasculine 8#273 /guillemotright\n');
  fprintf(epsFile,'8#274 /onequarter 8#275 /onehalf 8#276 /threequarters 8#277 /questiondown\n');
  fprintf(epsFile,'%% 0xC0\n');
  fprintf(epsFile,'8#300 /Agrave 8#301 /Aacute 8#302 /Acircumflex 8#303 /Atilde\n');
  fprintf(epsFile,'8#304 /Adieresis 8#305 /Aring 8#306 /AE 8#307 /Ccedilla\n');
  fprintf(epsFile,'8#310 /Egrave 8#311 /Eacute 8#312 /Ecircumflex 8#313 /Edieresis\n');
  fprintf(epsFile,'8#314 /Igrave 8#315 /Iacute 8#316 /Icircumflex 8#317 /Idieresis\n');
  fprintf(epsFile,'%% 0xD0\n');
  fprintf(epsFile,'8#320 /Eth 8#321 /Ntilde 8#322 /Ograve 8#323 /Oacute\n');
  fprintf(epsFile,'8#324 /Ocircumflex 8#325 /Otilde 8#326 /Odieresis 8#327 /multiply\n');
  fprintf(epsFile,'8#330 /Oslash 8#331 /Ugrave 8#332 /Uacute 8#333 /Ucircumflex\n');
  fprintf(epsFile,'8#334 /Udieresis 8#335 /Yacute 8#336 /Thorn 8#337 /germandbls\n');
  fprintf(epsFile,'%% 0xE0\n');
  fprintf(epsFile,'8#340 /agrave 8#341 /aacute 8#342 /acircumflex 8#343 /atilde\n');
  fprintf(epsFile,'8#344 /adieresis 8#345 /aring 8#346 /ae 8#347 /ccedilla\n');
  fprintf(epsFile,'8#350 /egrave 8#351 /eacute 8#352 /ecircumflex 8#353 /edieresis\n');
  fprintf(epsFile,'8#354 /igrave 8#355 /iacute 8#356 /icircumflex 8#357 /idieresis\n');
  fprintf(epsFile,'%% 0xF0\n');
  fprintf(epsFile,'8#360 /eth 8#361 /ntilde 8#362 /ograve 8#363 /oacute\n');
  fprintf(epsFile,'8#364 /ocircumflex 8#365 /otilde 8#366 /odieresis 8#367 /divide\n');
  fprintf(epsFile,'8#370 /oslash 8#371 /ugrave 8#372 /uacute 8#373 /ucircumflex\n');
  fprintf(epsFile,'8#374 /udieresis 8#376 /thorn 8#377 /ydieresis\n');
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
