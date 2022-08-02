%%NAME
%%  ejpgread  - read JPEG-file
%%
%%SYNOPSIS
%%  [image,head]=ejpgread(jpgFileName)
%%
%%PARAMETER(S)
%%  imageFileName  name of JPEG-file e.g. 'photo.jpg'
%%  image       whole JPEG-file in a vector of uchar
%%  head        1 x 4 vector, [sizeOfJpegFile rowsOfImage colsOfImage rgb]
%%              rgb=1 if color image, rgb=0 if black and white image
%%
% written by stefan.mueller@fgan.de (C) 2007
function [image,head]=ejpgread(filename)
  if (nargin >1)
    eusage('[image,head]=ejpgread(filename)');
  end
  jpgFile=fopen(filename ,'rb');
  [image n]=fread(jpgFile,inf,'uchar');
  fclose(jpgFile);
  ipos=3;
  while image(ipos)==255
    mark=image(ipos+1);
    nextMark=image(ipos+2)*256+image(ipos+3);
    if mark==192
      nrows=image(ipos+5)*256+image(ipos+6);
      ncols=image(ipos+7)*256+image(ipos+8); 
      if image(ipos+9)==3
        rgb=1;
      else
        rgb=0;
      end
    end
    ipos=ipos+nextMark+2;
  end
  head=[n nrows ncols rgb];
