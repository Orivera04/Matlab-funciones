%%NAME
%%  esymbol  - draw a defined symbol 
%%
%%SYNOPSIS
%%  esymbol(xPos,yPos,symbolName,[,scaleX[,scaleY[,rotation]]])
%%
%%PARAMETER(S)
%%  xPos          x position
%%  yPos          y position
%%  symbolName    name of defined symbol
%%  scaleX        scale factor in x-direction
%%  scaleY        scale factor in y-direction
%%  rotation      rotate symbol (deg)
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function esymbol(xPos,yPos,symbolName,scaleX,scaleY,rotation)
  if nargin<3 |nargin>6
    eusage('esymbol(xPos,yPos,symbolName,[,scaleX[,scaleY[,rotation]]])');
  end
  if nargin<6
    rotation=0;
  end
  if nargin<5
    scaleY=1;
  end
  if nargin<4
    scaleX=1;
  end
  eglobpar;
  fprintf(eFile,'gsave %1.2f %1.2f translate\n',xPos*eFac,yPos*eFac);
  fprintf(eFile,'%1.2f rotate\n',rotation);
  fprintf(eFile,'%1.2f %1.2f scale\n',scaleX,scaleY);
  fprintf(eFile,'%s grestore\n',symbolName);
