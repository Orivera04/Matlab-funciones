%%NAME
%%  eppmwrit  - save image as PPM-file 
%%
%%SYNOPSIS
%%  eppmwrit(filename,image,colormap[,binary])
%%
%%PARAMETER(S)
%%  filename    name of PPM-file
%%  image       matrix for image 
%%              if colormap=-1 then
%%                image is filled with RGB values
%%                value=R*2^16+G*2^8+B) and R,G,B are integer of 0:255
%%              else
%%                matrix is filled with indices of colormap  
%%  colormap    color table 
%%  binary      default: binary=1 for binary PPM-file 
%%              binary=0 for ascii PPM-file
%% 
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003
function eppmwrit (filename,image,colormap,binary)
  if (nargin<3) | (nargin>4)
    eusage('eppmwrit(filename,image,colormap[,binary])');
  end
% image matrix and colormap -> rgb-map
  if nargin<4 
    binary=1;
  end
  maxValue=255; 
  imgSize=size(image);
  if colormap(1,1)<0
     image=reshape(image',1,imgSize(1)*imgSize(2));
     rImg=fix(image/65536);
     image=image-rImg*65536;
     gImg=fix(image/256);
     bImg=image-gImg*256;
     data=[rImg;gImg;bImg];
     data=reshape(data,imgSize(1)*imgSize(2)*3,1);
  else
    colormap=colormap'*maxValue;
    image=reshape(image',1,imgSize(1)*imgSize(2));
    data=colormap(:,image);
    data=reshape(data,1,imgSize(1)*imgSize(2)*3);
  end

% write ppm-file
  ppmFile=fopen(filename ,'w');
  if binary
    fprintf(ppmFile,'P6\n');
  else
    fprintf(ppmFile,'P3\n');
  end
  fprintf(ppmFile,...
    '# Image generated %s by epsTk 2.0 stefan.mueller@fgan.de\n',date);
  fprintf(ppmFile,'%d %d\n',imgSize(2),imgSize(1));
  fprintf(ppmFile,'%d\n',maxValue);

  if binary
    n=fwrite(ppmFile,data,'uchar');
  else
    n=fprintf(ppmFile,'%d ',data);
  end
  fclose(ppmFile);
