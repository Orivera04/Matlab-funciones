%%NAME
%%  edsymbol - define symbols for plotting
%%
%%SYNOPSIS
%%  edsymbol(name,symbolFileName
%%           [,scaleX[,scaleY[,moveX[,moveY[,rotation[,color]]]]])
%%
%%PARAMETER(S)
%%  name             definition name for new symbol
%%  symbolFileName   pathname of an own postscript symbol definition file
%%                   or filename of a standard psd-file in the "ePsdPath"-directory
%%                   or string of postscript commands           
%%  scaleX           scale factor in X-direction
%%  scaleY           scale factor in Y-direction
%%  moveX            offset in X-direction
%%  moveY            offset in X-direction
%%  rotation         rotate symbol (deg)
%%  color            color vector [r g b], color of symbol
%% 
% written by stefan.mueller@fgan.de (C) 2007

function edsymbol(name,symbolFileName,scaleX,scaleY,moveX,moveY,...
                  rotation,color)
  if nargin<2 |nargin>8
    eusage('edsymbol(name,symbolFileName[,scaleX[,scaleY[,moveX[,moveY[,rotation[,color]]]]])');
  end
  if nargin<8
    color=[-1 0 0];
  end
  if nargin<7
    rotation=0;
  end
  if nargin<6
    moveY=0;
  end
  if nargin<5
    moveX=0;
  end
  if nargin<4
    scaleY=1;
    if nargin==3
      scaleY=scaleX;
    end
  end
  if nargin<3
    scaleX=1;
  end
  eglobpar;
  fprintf(eFile,'/%s { gsave %1.2f %1.2f translate \n',...
    name,moveX*eFac,moveY*eFac);
  fprintf(eFile,'%1.2f rotate\n',rotation);
  fprintf(eFile,'%1.2f %1.2f scale\n',scaleX,scaleY);
  if color(1)>=0
    fprintf(eFile,'%1.2f %1.2f %1.2f setrgbcolor\n',...
          color(1),color(2),color(3));
  end

  psdFileName=symbolFileName(find(symbolFileName~=' '));
  epsFile=fopen(psdFileName,'rb');
  if epsFile<2
    if exist('matlabpath')~=5
      psdFileName=file_in_path(ePsdPath, psdFileName); % only octave
    else
      psdFileName=[ePsdPath psdFileName];
    end
    if length(psdFileName)>0
      epsFile=fopen(psdFileName,'rb');
    end
  end
  if epsFile>1
    % get file length
    fseek(epsFile,0,1); 
    epsFileLength=ftell(epsFile);
    fclose(epsFile);
    bufferSize=100000;
    epsFile=fopen(psdFileName,'rb');
    nBuffer=fix(epsFileLength/bufferSize);
    tail=rem(epsFileLength,bufferSize);
    for i=1:nBuffer
      buffer=fread(epsFile,bufferSize,'char');
      fwrite(eFile,buffer,'char');
    end
    if tail>0
      buffer=fread(epsFile,tail,'char');
      fwrite(eFile,buffer,'char');
    end
    fclose(epsFile);
  else
    fprintf(eFile,'%s',symbolFileName);
  end
  fprintf(eFile,' grestore }def\n');
