%%NAME
%%  ebitmap  -  transform  the current eps-file to bitmap-file
%%
%%SYNOPSIS
%%  mapFileName=ebitmap([bitmapType[,resolution[,mapFileName[,epsFileName]]]])
%%
%%PARAMETER(S)
%%  bitmapType     bitmap-type
%%                 default: 0
%%                 0 = PNG -format
%%                 1 = JPEG-format 
%%                 2 = TIFF-format 
%%                 3 = PPM-format 
%%                 4 = PCX-format 
%%  resolution     in dpi,resolution of bitmap-file 
%%                 if scalar then resolution x and y direction are equal
%%                 default: 200  (dpi)
%%                 if [x y] vector then  resolution of x and y direction
%%                 if [x y q] vector then resolution and qualitiy of JPEG 
%%                     q=100 for no lost of qualitiy
%%                     q=75  standard compression
%%  mapFileName    name of bitmap-file
%%                 default: 'eFileName.typeSuffix' 
%%  epsFileName    name of eps-file
%%                 default: 'eFileName' 
%%GLOBAL PARAMETER(S)
%%  eFileName
%%  eGhostscript
% written by stefan.mueller stefan.mueller@fgan.de (C) 2003

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
    outputFormat='png256';
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
  end
  if nargin<2
    resolution=200;
  end
  if nargin<3
    pos=findstr(eFileName,'.eps');
    if length(pos)>0
      mapFileName=[eFileName(1:pos(1)) suffix];
    else
      mapFileName=[eFileName '.' suffix];
    end
  end
  if nargin<4
    epsFileName=eFileName;
  end

  headsize=500;
  epsFile=fopen(epsFileName,'r');
  data=fread(epsFile,headsize,'uchar');
  fclose(epsFile);

  head=setstr(data');
  pos=findstr(head,'epsTk');
  if length(pos)<1
    pos=findstr(head,'BoundingBox:')+12;
    win=sscanf(head(pos(1):pos(1)+40),'%f',4);
    win=win/eFac;
    xPos=win(1);
    yPos=win(2);
    width=win(3)-win(1);
    height=win(4)-win(2);
   
    eFileNameSave=eFileName;
    eopen(mapFileName,0,width,height,[0 0]);
    einseps(0,0,epsFileName);
    eclose(1,0);
    epsFileName=mapFileName;
    eFileName=eFileNameSave;
  end

  epsFile=fopen(epsFileName,'r');
  data=fread(epsFile,inf,'uchar');
  fclose(epsFile);
  headsize=500;
  head=setstr(data(1:headsize)');
  pos=findstr(head,'BoundingBox:')+12;
  win=sscanf(head(pos(1):headsize),'%f',4);
  match=sscanf(head(pos(1):headsize),'%s',1);
  pos=findstr(head,match);
  if length(pos)>1
    pos2=findstr(head,'translate')+8;
    data(pos(2):pos2(1))=ones(1,(pos2(1)-pos(2)+1))*32; 
  end
  mapFile=fopen(mapFileName,'w');
  fwrite(mapFile,data,'uchar');
  fclose(mapFile);

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
  eGhostscript,options,pixelSize,resDpi,device,outFileName,mapFileName);
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
