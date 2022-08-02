%%NAME
%%  eellipse  - draw ellipse 
%%
%%SYNOPSIS
%%  eellipse(xPos,yPos,width,height[,lineWidth[,dash[,color
%%         [,rotation]]]])
%%
%%PARAMETER(S)
%%  xPos          x-Position of center of ellipse
%%  yPos          y-Position of center of ellipse
%%  width         width of ellipse
%%  height        height of ellipse
%%  lineWidth     linewidth of ellipse 
%%                default: lineWidth=eLineWidth
%%  dash          if a scalar and 
%%                  dash=0 draw solid line,
%%                  dash>0 set the dash length,
%%                  dash<0 fill ellipse with color,
%%                default: dash=eLineDash
%%                if a matrix and color=-1
%%                  dash is the image of ellipse 
%%                  and filled with RGB values
%%                  (value=R*2^16+G*2^8+B and R,G,B are integer of 0:255)
%%                if a matrix and color is a colormap
%%                  dash is the image of ellipse 
%%                  and filled with indices of colormap
%%                if a string dash is filename of a JPEG-file
%%  color         if dash>=0 vector of ellipse color ([r g b])
%%                if dash<0  vector of background color 
%%                if dash a matrix then colormap of image or -1
%%                default: dash=eLineColor
%%  rotation      rotation of ellipse (in deg)
%% 
%%GLOBAL PARAMETER(S)
%%  eLineWidth
%%  eLineDash
%%  eLineColor
% written by stefan.mueller@fgan.de (C) 2007

function eellipse (xPos,yPos,width,height,lineWidth,dash,color,rotation,cornerRadius)
  if nargin<4 | nargin>8
    eusage('eellipse(xPos,yPos,width,height[,lineWidth[,dash[,color[,rotation[,cornerRadius]]]]])');
  end
  eglobpar;
  if nargin<8
    rotation=0;
  end
  if nargin<7
    color=eLineColor;
  end
  if nargin<6
    dash=eLineDash;
  end
  if nargin<5
    lineWidth=eLineWidth;
  end
  eellipxy(eFile,xPos*eFac,yPos*eFac,width*eFac,height*eFac,...
            lineWidth*eFac,color,dash,rotation);
