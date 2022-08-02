%%NAME
%%  econtra  - change contra of colormap 
%%
%%SYNOPSIS
%%  newColormap=econtra(colormap,contrast[,colorChannel])
%%
%%PARAMETER(S)
%%  colormap      color table
%%  contrast      -200 to 200 per cent 
%%  newColormap   changed color table
%%  colorChannel  vector of Channel; 1=red, 2=green, 3=blue
%%                e.g. [1 3] = Channel red and blue
%%                default=[1 2 3]
%% 
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003
function newColormap= econtra (colormap,contrast,colorChannel)
  if nargin <2 | nargin >3
    eusage('newColormap = econtra(colormap,contrast[,colorChannel])');
  end
  if nargin<3
    colorChannel=[1 2 3];
  end

  newColormap=colormap(:,colorChannel);
  [rows cols]=size(newColormap);
  newColormap=reshape(newColormap,rows*cols,1);
  if contrast<0
    if contrast<-200
      contrast=-200;
    end
    a=-0.5*contrast/100;
    b=(1-2*a);
    newColormap=newColormap*b+a;
  else
    if contrast>200
      contrast=200;
    end
    a=0.5*contrast/100;
    b=(1-2*a);
    if b*b<eps 
      b=eps;
    end
    newColormap=(newColormap-a)/b;
    newColormap(find(newColormap>1))=1;
    newColormap(find(newColormap<0))=0;
  end
  newColormap=reshape(newColormap,rows,cols);
  colormap(:,colorChannel)=newColormap;
  newColormap=colormap;

