%%NAME
%%  etxtbox  -  write text in a box
%%
%%SYNOPSIS
%%  etxtbox(text[,x[,y[,boxWidth[,boxHeight[,fontSize[,alignment
%%           [,font[,rotation[,color[,offset]]]]]]]]]])
%%
%%PARAMETER(S)
%%  text          text string 
%%  x             x of start position
%%  y             y of start position
%%  boxWidth      width of textbox
%%                default=eWinWidth
%%  boxHeight     height of textbox  
%%  fontSize      scalar size of current font
%%                or vector [xSize ySize obliqueAngle(in deg)] of current font
%%  alignment     1=right 0=center -1=left 2=block
%%  font          font number (definition in einit.m)
%%  rotation      rotation of box (in deg)
%%  color         color of text, [r g b] vector 
%%  offset        offset vector [x y] of text, default offset=[0 0]
%%
%%GLOBAL PARAMETER(S)
%%  eTextColor
%%  eTextFont
%%  eTextAlignment
%%  eTextFontSize
%%  eTextLimitWord
%%  eTextLimitPara
%%  eTextBoxFeedLine
%%  eTextBoxFeedPara
% written by stefan.mueller@fgan.de (C) 2007

function etxtbox(text,x,y,boxWidth,boxHeight,fontSize,alignment,font,rotation,color,offset)
  if nargin<1 | nargin>11
    eusage('etxtbox(text[,x[,y[,boxWidth[,boxHeight[,fontSize[,alignment[,font[,rotation[,color[,offset]]]]]]]]]])');
  end
  eglobpar;
  if nargin<11
    offset=[0 0];
  end
  if nargin<10
    color=eTextColor;
  end
  if nargin<9
    rotation =0;
  end
  if nargin<8
    font=eTextFont;
  end
  if nargin<7
    alignment=eTextAlignment;
  end
  if nargin<6
    fontSize=eTextFontSize;
  end
  if nargin<5
    boxHeight=eWinHeight;
  end
  if nargin<4
    boxWidth=eWinWidth;
  end
  if nargin<3
    x=0;
    y=0;
  end
  if length(fontSize)==3
    lineFeed=fontSize(2);
    fontSize=[fontSize(1:2)*eFac fontSize(3)];
  else
    lineFeed=fontSize;
    fontSize=fontSize*eFac;
  end
  if eTextBoxFeedLine~=0
    lineFeed=eTextBoxFeedLine;
  end
  fprintf(eFile,'gsave\n');
  fprintf(eFile,'%1.2f %1.2f translate\n',x*eFac,y*eFac);
  fprintf(eFile,'%1.2f rotate\n',rotation);
  etxt2box(eFile,text,0,0,boxWidth*eFac,boxHeight*eFac,...
    lineFeed*eFac,eTextBoxFeedPara*eFac,...
    eTextLimitWord,eTextLimitPara,...
    alignment,eFonts(font,:),fontSize,color,...
    eTextBoxSpaceNorth*eFac,eTextBoxSpaceWest*eFac,...
    eTextBoxSpaceEast*eFac,eTextBoxSpaceSouth*eFac,offset*eFac); 
  fprintf(eFile,'grestore\n');
