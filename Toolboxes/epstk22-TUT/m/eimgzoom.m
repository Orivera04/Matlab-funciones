%%NAME
%%  eimgzoom  - resize image with linear interpolation
%%              (note: use 'ematrsnn' for a quick resize)     
%%
%%SYNOPSIS
%%  [newimage newcolormap]=eimgzoom(image,colormap,scale)
%%
%%PARAMETER(S)
%%  image        old image matrix 
%%  colormap     color table
%%  scale        scale factor (1=no resize, 2=double size, 0.5=half size)
%%  newimage     new image matrix 
%%  newcolormap  new colormap
%% 
% written by stefan.mueller@fgan.de (C) 2007
function [newimage,newcolormap]= eimgzoom (image,colormap,scale)
  if (nargin ~= 3)
    eusage('[newimage newcolormap] = eimgzoom(image,colormap,scale)');
  end

  eglobpar
  if exist('eFac')
    if isempty(eFac)
      einit;
    end
  else
    einit;
  end
  oldSize=size(image);
  newSize=fix(oldSize*scale);
  if colormap(1,1)<0
    [r g b]=ergbsplitt(image);
  else
    image=reshape(image,1,oldSize(1)*oldSize(2));
    cm=colormap(:,1);
    r=reshape(cm(image),oldSize(1),oldSize(2));
    cm=colormap(:,2);
    g=reshape(cm(image),oldSize(1),oldSize(2));
    cm=colormap(:,3);
    b=reshape(cm(image),oldSize(1),oldSize(2));
  end
   r=ematrsli(r,newSize(1),newSize(2));
   g=ematrsli(g,newSize(1),newSize(2));
   b=ematrsli(b,newSize(1),newSize(2));
  newimage=bitshift(fix(r*255),16)+bitshift(fix(g*255),8)+fix(b*255);
  if colormap(1,1)<0
    newcolormap=-1;
  else
    [newimage newcolormap]=ergb2idx(newimage);
  end
