%%NAME
%%  eimgwrit  - write image-file
%%
%%SYNOPSIS
%%  eimgwrit(imageFileName,image,colormap,quality)
%%
%%PARAMETER(S)
%%  imageFileName  name of image-file
%%                 possible suffixes: png,jpg,tif,ppm,pcx,txt
%%  image          matrix for image
%%                 if colormap=-1 then
%%                   image is filled with RGB values
%%                   (value=R*2^16+G*2^8+B and R,G,B are integer of 0:255)
%%                 else
%%                   matrix is filled with indices of colormap
%%  colormap       color table
%%  quality        quality of JPEG-files, default=75  (%)
%%
% written by stefan.mueller@fgan.de (C) 2007
function eimgwrit(imageFileName,image,colormap,quality)
  if nargin>4
    eusage('eimgwrit(imageFileName,image,colormap[,quality])');
  end
  eglobpar;
  if nargin<4
    quality=75;
  end
  if exist('ePath')
    if isempty(ePath)
      einit;
    end
  else
      einit;
  end
  pos0=findstr(imageFileName,'.png');
  pos1=findstr(imageFileName,'.jpg');
  pos2=findstr(imageFileName,'.tif');
  pos3=findstr(imageFileName,'.ppm');
  pos4=findstr(imageFileName,'.pcx');
  pos5=findstr(imageFileName,'.txt');
  epsFileName=imageFileName;
  if length(pos0);
    type=0;
    pos=pos0;
  elseif length(pos1)
    type=1;
    pos=pos1;
  elseif length(pos2)
    type=2;
    pos=pos2;
  elseif length(pos3)
    type=3;
    pos=pos3;
  elseif length(pos4)
    type=4;
    pos=pos4;
  elseif length(pos5)
    type=5;
    pos=pos5;
  end
  eglobpar;
  if exist('eFac')
    if isempty(eFac)
      einit;
    end
  else
    einit;
  end
  if type==3
    eppmwrit(imageFileName,image,colormap);
  elseif type==5
    text=eimg2txt(image,colormap); 
    [rows cols]=size(text);
    fid=fopen(imageFileName,'wb');
    for i=1:rows
      fprintf(fid,'%s\n',text(i,:));      
    end
    fclose(fid);
  else
    [imgH imgW]=size(image);
    imgFac=imgH/imgW;
    winFac=eWinHeight/eWinWidth;
    if winFac<imgFac
      eWinWidth=eWinHeight/imgFac;
      dpi=imgH*72/eWinHeight/eFac;
    else
      eWinHeight=eWinWidth*imgFac;
      dpi=imgW*72/eWinWidth/eFac;
    end
    offsetX=1.2*eWinWidth/imgW;
    offsetY=1.2*eWinHeight/imgH;
    eopen(epsFileName,0,eWinWidth,eWinHeight)
    eframe(0,0,eWinWidth+offsetX,eWinHeight+offsetY,0,image,colormap);
    eclose(1,0);
    ebitmap(type,[dpi dpi quality],imageFileName);
  end
