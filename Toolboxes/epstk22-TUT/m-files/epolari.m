%%NAME
%%  epolari  - draw polar image of a matrix 
%%
%%SYNOPSIS
%%  epolari(matrix[,colorMap])
%%
%%PARAMETER(S)
%%  matrix     matrix for image 
%%             if colorMap=-1 then
%%                image is filled with RGB values
%%                value=R*2^16+G*2^8+B) and R,G,B are integer of 0:255
%%              else
%%                matrix is filled with indices of colormap  
%%  colorMap   define own colormap  
%%             default:colorMap=ecolors(eImageDefaultColorMap)
%% 
%%GLOBAL PARAMETER(S)
%%  eImageDefaultColorMap
%%  ePolarPlotAreaCenterPos
%%  ePolarPlotAreaRadMax
%%  ePolarPlotAreaAngEnd
%%  ePolarPlotAreaAngStart
%%  ePolarPlotAreaRadMin
%%  ePolarPlotAreaRadMax
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function epolari(matrix,colorMap)
  if nargin>5
    eusage('epolari(matrix[,colorMap])');
  end
  eglobpar;
  if nargin<2
    colorMap=ecolors(eImageDefaultColorMap);
  end
  if nargin<1
    [matrix colorMap]=eppmread([ePath 'default.ppm']);
    ePlotTitleText='Photo';     
  end

  % write title
  eptitle;

  nSteps=size(matrix,2);
  dPhi=(ePolarPlotAreaAngEnd-ePolarPlotAreaAngStart)/nSteps;
  radiusMin=ePolarPlotAreaRadMin*eFac;
  radiusMax=ePolarPlotAreaRadMax*eFac;
  dRadius=radiusMax-radiusMin;
  sectorH=dPhi/180*pi*radiusMax;
  fprintf(eFile,'gsave %1.2f %1.2f translate\n',...
           ePolarPlotAreaCenterPos(1)*eFac,...
           ePolarPlotAreaCenterPos(2)*eFac);
  fprintf(eFile,'%1.2f rotate\n',ePolarPlotAreaAngStart+dPhi/2);
  for i=1:nSteps
    fprintf(eFile,'%1.2f rotate\n',dPhi*(i-1));
    eclippol(eFile,0,0,radiusMin,radiusMax,-dPhi/2,dPhi/2);
    eimagexy(eFile,matrix(:,i)',colorMap,...
             radiusMin,-sectorH/2,dRadius,sectorH);
    eclippol(eFile);
    fprintf(eFile,'%1.2f rotate\n',-dPhi*(i-1));
  end
  fprintf(eFile,'grestore\n');
