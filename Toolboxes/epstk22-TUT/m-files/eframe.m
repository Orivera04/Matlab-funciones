%%NAME
%%  eframe  - draw frame 
%%
%%SYNOPSIS
%%  eframe(xPos,yPos,width,height[,lineWidth[,dash[,color
%%         [,rotation[,cornerRadius]]]]])
%%
%%PARAMETER(S)
%%  xPos          x-Position of sw-corner of frame
%%  yPos          y-Position of sw-corner of frame
%%  width         width of frame
%%  height        height of frame
%%  lineWidth     linewidth of frame 
%%                default: lineWidth=eLineWidth
%%  dash          if a scalar
%%                  =0  solid frame,
%%                  >0  dash length
%%                  <0  fill frame with color
%%                default: dash=eLineDash
%%                if a matrix and color=-1
%%                  dash is the image of frame 
%%                  and filled with RGB values
%%                  value=R*2^16+G*2^8+B) and R,G,B are integer of 0:255
%%                if a matrix and color is a colormap
%%                  dash is the image of frame 
%%                  and filled with indices of colormap
%%                if a string then dash is filename of a JPEG-file
%%  color         if dash>=0 vector of frame color ([r g b])
%%                if dash<0  vector of background color 
%%                if dash a matrix then colormap of image or -1
%%                default: dash=eLineColor
%%  rotation      rotation of frame (in deg)
%%  cornerRadius  radius of rounded corner 
%%                default: 0=no rounded corner
%% 
%%GLOBAL PARAMETER(S)
%%  eLineWidth
%%  eLineDash
%%  eLineColor
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function eframe (xPos,yPos,width,height,lineWidth,dash,color,rotation,cornerRadius)
  if nargin<4 | nargin>9
    eusage('eframe(xPos,yPos,width,height[,lineWidth[,dash[,color[,rotation[,cornerRadius]]]]])');
  end
  eglobpar;
  if nargin<9
    cornerRadius=0;
  end
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
  if cornerRadius>0
    erectrc(eFile,xPos*eFac,yPos*eFac,width*eFac,height*eFac,...
            lineWidth*eFac,color,dash,rotation,cornerRadius*eFac);
  else
    erect(eFile,xPos*eFac,yPos*eFac,width*eFac,height*eFac,...
            lineWidth*eFac,color,dash,rotation);
  end
