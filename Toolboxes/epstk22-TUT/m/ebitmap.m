%%NAME
%%  ebitmap  -  transform  the current eps-file to bitmap-file
%%
%%SYNOPSIS
%%  mapFileName=ebitmap([bitmapType[,resolution[,mapFileName[,epsFileName]]]])
%%
%%PARAMETER(S)
%%  bitmapType     type of bitmap
%%                 0 = PNG-format
%%                 1 = JPEG-format 
%%                 2 = TIFF-format 
%%                 3 = PPM-format 
%%                 4 = PCX-format 
%%                 5 = PDF-format 
%%                 default: 0
%%
%%  resolution     in dpi,resolution of bitmap-file 
%%                 if scalar then resolution x and y direction are equal
%%                 default: 200  (dpi)
%%                 if a [x y] vector then  resolution of x and y direction
%%                 if a [x y q] vector then resolution and qualitiy of JPEG 
%%                     q=100 for no lost of qualitiy
%%                     q=75  standard compression
%%
%%  mapFileName    name of bitmap-file
%%                 default: 'eFileName.typeSuffix' 
%%  epsFileName    name of eps-file
%%                 default: 'eFileName' 
%%
%%GLOBAL PARAMETER(S)
%%  eFileName
%%  eGhostscript
% written by stefan.mueller@fgan.de (C) 2007

function mapFileName=ebitmap(bitmapType,resolution,mapFileName,epsFileName)
  if nargin>4
    eusage('mapFileName=ebitmap([bitmapType[,resolution[,mapFileName[,epsFileName]]]])');
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
    bitmapType=0;
  end
  if nargout>0
    message=0;
  else
    message=1;
  end
  if bitmapType<0
   error
  end
  if bitmapType==0
    outputFormat='png16m';
    suffix='png';
  elseif bitmapType==1
    outputFormat='jpeg';
    suffix='jpg';
  elseif bitmapType==2
    outputFormat='tiff24nc';
    suffix='tif';
  elseif bitmapType==3
    outputFormat='ppmraw';
    suffix='ppm';
  elseif bitmapType==4
    outputFormat='pcx24b';
    suffix='pcx';
  elseif bitmapType==5
    outputFormat='pdfwrite';
    suffix='pdf';
  end
  if nargin<2
    resolution=200;
  end
  if nargin<3
    pos=findstr(eFileName,'.eps');
    if isempty(pos)
      mapFileName=[eFileName '.' suffix];
    else
      mapFileName=[eFileName(1:pos(1)) suffix];
    end
  end
  if nargin<4
    epsFileName=eFileName;
  end
  tmpFileName=[eFileName '.tmp'];

  headsize=500;
  epsFile=fopen(epsFileName,'rb');
  data=fread(epsFile,headsize,'uchar');
  fclose(epsFile);

  head=setstr(data');
  pos=findstr(head,'epsTk');
  if isempty(pos)
    pos=findstr(head,'BoundingBox:')+12;
    win=sscanf(head(pos(1):pos(1)+40),'%f',4);
    win=win/eFac;
    xPos=win(1);
    yPos=win(2);
    width=win(3)-win(1);
    height=win(4)-win(2);
    esavpar2 
    eopen(tmpFileName,0,width,height,[0 0]);
    einseps(0,0,epsFileName);
    eclose(1,0);
    erespar2 
    epsFileName=tmpFileName;
  end

  epsFile=fopen(epsFileName,'rb');
  [data n]=fread(epsFile,inf,'uchar');
  fclose(epsFile);
  headsize=500;
  head=setstr(data(1:headsize)');
  pos=findstr(head,'BoundingBox:')+12;
  win=sscanf(head(pos(1):pos(1)+40),'%f',4);
  pos=findstr(head,'translate')+9;
  tmpFile=fopen(tmpFileName,'wb');
  fwrite(tmpFile,data(1:pos(1)),'uchar');
  fprintf(tmpFile,'%d %d translate\n',-win(1),-win(2));
  fwrite(tmpFile,data(pos(1)+1:n),'uchar');
  fclose(tmpFile);

  if size(resolution,2)>2
    quality=round(resolution(1,3));
  else
    quality=75;
  end
  options=sprintf('-q -dNOPAUSE -dSAFER -dBATCH -dJPEGQ=%d',quality);
  xResolution=resolution(1,1);
  yResolution=resolution(1,1);
  if size(resolution,2)>1
    yResolution=resolution(1,2);
  else
    yResolution=resolution(1,1);
  end
  xPixel=round((win(3)-win(1))/72*xResolution);
  yPixel=round((win(4)-win(2))/72*yResolution); 
  pixelSize=sprintf('-g%dx%d',fix(xPixel),fix(yPixel));
  resDpi=sprintf('-r%d',resolution);
  device=sprintf('-sDEVICE=%s',outputFormat);
  outFileName=sprintf('-sOutputFile=%s',mapFileName);
  ghostscript=sprintf('%s %s %s %s %s %s %s',...
    eGhostscript,options,pixelSize,resDpi,device,...
    outFileName,tmpFileName);
  if isempty(eGhostscript)
    disp('ebitmap: sorry, no ghostscript installed');
  else
    if exist('matlabpath')~=5
      system(ghostscript);
    else
      unix(ghostscript);
    end
    if message
      message=sprintf('%s is written',mapFileName);
      disp(message);
    end
  end
  delete(tmpFileName);
