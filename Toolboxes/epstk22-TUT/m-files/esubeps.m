%%NAME
%%  esubeps  -  insert eps-file in a subarea of the window
%%
%%SYNOPSIS
%%  esubeps(nRows,nColumns,row,column,epsFileName)
%%
%%PARAMETER(S)
%%  nRows         number of rows of the window
%%  nColumns      number of columns of the windows
%%  row           index of row
%%  column        index of column
%%  epsFileName   name of eps-file
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function esubeps(nRows,nColumns,row,column,epsFileName)
  if nargin~=5
    eusage('esubeps(nRows,nColumns,row,column,epsFileName)');
  end
  eglobpar;
  tWidth=eWinWidth/nColumns;
  tHeight=eWinHeight/nRows;

  % read box
  headsize=500;
  epsFile=fopen(epsFileName,'r');
  if epsFile>0
    head=fread(epsFile,headsize,'uchar');
    fclose(epsFile);
    head=setstr(head');
    pos=findstr(head,'BoundingBox:')+12;
    win=sscanf(head(pos(1):pos(1)+40),'%f',4);

    % resize fac
    boxWidth=(win(3)-win(1))/eFac;
    boxHeight=(win(4)-win(2))/eFac;
    rFacW=tWidth/boxWidth;
    rFacH=tHeight/boxHeight;
    if rFacW<rFacH
     rFac=rFacW;
    else
     rFac=rFacH;
    end
    xPos=(column-1)*tWidth;
    yPos=(nRows-row)*tHeight;
    einseps(xPos,yPos,epsFileName,rFac,rFac); 
  end
