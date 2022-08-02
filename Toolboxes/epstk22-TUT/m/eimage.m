%%NAME
%%  eimage  - draw image of a matrix 
%%
%%SYNOPSIS
%%  eimage(matrix[,colorMap])
%%
%%PARAMETER(S)
%%  matrix     rows x cols matrix for image 
%%               if colorMap=-1 then
%%                  image is filled with RGB values
%%                  (value=R*2^16+G*2^8+B and R,G,B are integer of 0:255)
%%                else
%%                  matrix is filled with indices of colormap  
%%             or a string of filename of a JPEG-file
%%  colorMap   define own colormap  
%%             default:colorMap=ecolors(eImageDefaultColorMap)
%% 
%%GLOBAL PARAMETER(S)
%%  eImageDefaultColorMap 
%%  ePlotAreaPos
%%  ePlotAreaWidth
%%  ePlotAreaHeight
%%  eImageFrameVisible
%%  eAxesLineWidth
% written by stefan.mueller@fgan.de (C) 2007

function eimage(matrix,colorMap)
  if  nargin >2
    eusage('eimage(matrix[,colorMap])');
  end
  eglobpar;
  if nargin<2
    colorMap=ecolors(eImageDefaultColorMap); 
  end
  if nargin<1
    matrix=eppmread;
    colorMap=-1;
  end
  % write title
  etitle;
  eimagexy(eFile,matrix,colorMap,...
           ePlotAreaPos(1)*eFac,ePlotAreaPos(2)*eFac,...
           ePlotAreaWidth*eFac,ePlotAreaHeight*eFac);
  if eImageFrameVisible
    erect(eFile,ePlotAreaPos(1)*eFac,ePlotAreaPos(2)*eFac,...
          ePlotAreaWidth*eFac,ePlotAreaHeight*eFac,...
          eAxesLineWidth*eFac,[0 0 0],0,0);
  end
