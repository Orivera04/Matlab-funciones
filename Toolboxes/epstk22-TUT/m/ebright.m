%%NAME
%%  ebright  - change brightness of colormap 
%%
%%SYNOPSIS
%%  newColormap=ebright(colormap,brightness[,colorChannel])
%%
%%PARAMETER(S)
%%  colormap      color table
%%  brightness    +/- brigthness in per cent 
%%  colorChannel  vector of Channel; 1=red, 2=green, 3=blue
%%                e.g. [1 3] = Channel red and blue
%%                default=[1 2 3]
%%  newColormap   changed color table
%% 
% written by stefan.mueller@fgan.de (C) 2007
function newColormap= ebright (colormap,brightness,colorChannel)
  if nargin <2 | nargin >3
    eusage('newColormap = ebright(colormap,brightness[,colorChannel])');
  end
  if nargin<3
    colorChannel=[1 2 3];
  end

  newColormap=colormap(:,colorChannel);
  [rows cols]=size(newColormap);
  newColormap=reshape(newColormap,rows*cols,1);
  if brightness<0
    if brightness<-100
      brightness=-100;
    end
    a=1+brightness/100;
    newColormap=newColormap*a;
  else
    if brightness>100
      brightness=100;
    end
    a=brightness/100;
    b=1-a;
    newColormap=newColormap*b+a;
  end
  newColormap=reshape(newColormap,rows,cols);
  colormap(:,colorChannel)=newColormap;
  newColormap=colormap;

