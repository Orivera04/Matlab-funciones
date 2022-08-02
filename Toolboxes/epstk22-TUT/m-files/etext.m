%%NAME
%%  etext  -  write text
%%
%%SYNOPSIS
%%  etext(text[,x[,y[,fontSize[,alignment[,font[,rotation[,color]]]]]]])
%%
%%PARAMETER(S)
%%  text          text string 
%%  x             x of start position
%%                if x=0 then the text starts after 
%%                the last text in the same line
%%  y             y of start position
%%                if x=0 then y is a relativ position to the current line 
%%  fontSize      scalar size of current font
%%                or vector [xSize ySize obliqueAngle(in deg)] of current font
%%  alignment     1=right 0=center -1=left from x-positon, y = line position 
%%                2=right 3=center 4=left from x-positon, y = height of text/2 
%%  font          font number (definition in einit.m)
%%  rotation      rotation of text (in deg)
%%  color         color of text, [r g b] vector 
%%
%%GLOBAL PARAMETER(S)
%%  eTextColor
%%  eTextRotation
%%  eTextFont
%%  eTextAlignment
%%  eTextFontSize
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function etext(text,x,y,fontSize,alignment,font,rotation,color)
  if nargin<1 | nargin>8
    eusage('etext(text[,x[,y[,fontSize[,alignment[,font[,rotation[,color]]]]]]])');
  end
  eglobpar;
  if nargin<8
    color=eTextColor;
  end
  if nargin<7
    rotation=eTextRotation;
  end
  if nargin<6
    font=eTextFont;
  end
  if nargin<5
    alignment=eTextAlignment;
  end
  if nargin<4
    fontSize=eTextFontSize;
  end
  if nargin<3
    x=0;
    y=0;
  end
  if length(fontSize)==3
    fontSize=[fontSize(1:2)*eFac fontSize(3)];
  else
    fontSize=fontSize*eFac;
  end
  etextxy(eFile,...
          x*eFac,y*eFac,rotation,alignment,text,eFonts(font,:),...
          fontSize,color); 
