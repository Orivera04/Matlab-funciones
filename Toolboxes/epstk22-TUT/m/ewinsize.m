%%NAME
%%  ewinsize  -  get size of Bounding Box of eps-file 
%%
%%SYNOPSIS
%%  [width,height]=ewinsize([epsFileName])
%%
%%PARAMETER(S)
%%  epsFileName   name of eps-file 
%%                default: current eFileName
% written by stefan.mueller@fgan.de (C) 2007

function [width,height]=ewinsize(epsFileName)
  if nargin>1
    eusage('[width height]=ewinsize([epsFileName])');
  end
  eglobpar;
  if exist('eFac')
    if isempty(eFac)
      einit;
    end
  else
    einit;
  end
  if nargin<1
    epsFileName=eFileName;
  end

  % read eps file
  epsFile=fopen(epsFileName,'rb');
  if epsFile<0
    errortext=sprintf('error in ewinsize: can not open %s',epsFileName);
    disp(errortext);
  else
    [data dl]=fread(epsFile,inf,'uchar');
    fclose(epsFile);
    headsize=500;
    head=setstr(data(1:headsize)');
  
    % read box
    pos=findstr(head,'BoundingBox:')+12;
    win=sscanf(head(pos(1):pos(1)+40),'%f',4);
    width=(win(3)-win(1))/eFac; 
    height=(win(4)-win(2))/eFac; 
  end
