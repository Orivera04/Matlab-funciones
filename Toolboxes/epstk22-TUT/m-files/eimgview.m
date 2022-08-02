%%NAME
%%  eimgview  - create and view eps-file of an image
%%
%%SYNOPSIS
%%  eimgview(matrix[,colorMap[,epsFileName]])
%%
%%PARAMETER(S)
%%  matrix      matrix for image
%%              if colorMap=-1 then
%%                matrix is filled with RGB values
%%                value=R*2^16+G*2^8+B) and R,G,B are integer of 0:255
%%              else
%%                matrix is filled with indices of colorMap
%%              or a string of filename of a JPEG-file
%%  colorMap    own colormap
%%              default:colorMap=ecolors(eImageDefaultColorMap)
%%  epsFileName default=eFileName
%%
% written by stefan.mueller stefan.mueller@fgan.de (C) 2003
function eimgview(matrix,colorMap,epsFileName)
  if nargin>3
    eusage('eimgview(matrix[,colorMap[,epsFileName]])');
  end
  eglobpar;
  if exist('eFac')
    if isempty(eFac)
      einit;
    end
  else
    einit;
  end
  if nargin<3
    epsFileName=eFileName;
  end
  if nargin<2
    colorMap=ecolors(eImageDefaultColorMap); 
  end
  if nargin<1
    matrix=[ePath 'default.jpg'];
  end
  eglobpar;
  if exist('ePath')
    if isempty(ePath)
      einit;
    end
  else
      einit;
  end
  if isstr(matrix)
    ejpg2eps(matrix,epsFileName);
  else 
    if colorMap(1,1)<0
      [matrix colorMap]=ergb2idx(matrix);
    end
    [imgH imgW]=size(matrix);
    imgFac=imgH/imgW;
    winFac=eWinHeight/eWinWidth;
    if winFac<imgFac
      eWinWidth=eWinHeight/imgFac;
    else
      eWinHeight=eWinWidth*imgFac;
    end
    offsetX=eWinWidth*eFac/imgW/2;
    offsetY=eWinHeight*eFac/imgH/2;
    eopen(epsFileName,0,eWinWidth,eWinHeight)
    fprintf(eFile,'%1.2f %1.2f translate\n',offsetX,offsetY);
    eframe(0,0,eWinWidth,eWinHeight,0,matrix,colorMap);
    eclose(1,0);
  end
  eview;
