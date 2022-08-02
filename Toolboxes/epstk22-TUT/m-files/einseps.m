%%NAME
%%  einseps  -  insert eps-file 
%%
%%SYNOPSIS
%%  einseps(xPos,yPos,epsFileName,[,scaleX[,scaleY[,rotation]]])
%%
%%PARAMETER(S)
%%  xPos          x position
%%  yPos          y position
%%  epsFileName   name of eps-file 
%%  scaleX        scale factor in x-direction
%%  scaleY        scale factor in y-direction
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function einseps(xPos,yPos,epsFileName,scaleX,scaleY,rotation)
  if nargin<3 | nargin>6
    eusage('einseps(xPos,yPos,epsFileName,[,scaleX[,scaleY[,rotation]]])');
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

  % read eps file
  epsFile=fopen(epsFileName,'r');
  if epsFile>0
    [data dl]=fread(epsFile,inf,'uchar');
    fclose(epsFile);
    headsize=500;
    head=setstr(data(1:headsize)');
  
    % read box
    pos=findstr(head,'BoundingBox:')+12;
    win=sscanf(head(pos(1):pos(1)+40),'%f',4);
  
    % delete showpage
    pos=dl-headsize;
    tail=setstr(data(pos:dl)');
    pos2=findstr(tail,'showpage');
    data(pos+pos2(1)-1:pos+pos2(1)+6)=32;
  
    % write head
    fprintf(eFile,'gsave %1.2f %1.2f translate\n',xPos*eFac,yPos*eFac);
    fprintf(eFile,'%1.2f rotate\n',rotation);
    fprintf(eFile,'%1.2f %1.2f translate\n',-win(1)*scaleX,-win(2)*scaleY);
    fprintf(eFile,'%1.2f %1.2f scale\n',scaleX,scaleY);
  
    % insert eps file
    fwrite(eFile,data,'uchar');
    fprintf(eFile,'grestore\n');
  end
