%%NAME
%%  eimgread  - read image-file
%%
%%SYNOPSIS
%%  [image,colormap]=eimgread(imageFileName)
%%
%%PARAMETER(S)
%%  imageFileName  name of JPEG- or PPM-file 
%%  image          image matrix
%%                 if colormap used then
%%                   image is filled with indices of colormap
%%                 else
%%                   image is filled with RGB values
%%                   value=R*2^16+G*2^8+B) and R,G,B are integer of 0:255
%%                   that's a very fast way
%%  colormap       color table
%%
% written by stefan.mueller stefan.mueller@fgan.de (C) 2003
function [image,colormap]=eimgread(imageFileName)
  if nargin>1
    eusage('[image,colormap]=eimgread(imageFileName)');
  end
  eglobpar;
  if exist('ePath')
    if isempty(ePath)
      einit;
    end
  else
      einit;
  end
  if nargin<1
    imageFileName=[ePath 'default.ppm'];
  end

  jpgpos=findstr(imageFileName,'.jpg');
  ppmpos=findstr(imageFileName,'.ppm');
  if length(jpgpos)
    esavpar;
    tempFileName='imgread.ppm';
    dpi=ejpg2eps(imageFileName,'imgread.eps');
    tempFileName=ebitmap(3,dpi,tempFileName,'imgread.eps');
    erespar;
  elseif length(ppmpos) 
    tempFileName=imageFileName;
  end
  if nargout==2
    [image colormap]=eppmread(tempFileName);
  else
    image=eppmread(tempFileName);
  end
