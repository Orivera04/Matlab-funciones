%%NAME
%%  eimgrot  - rotate image 
%%
%%SYNOPSIS
%%  matrix=eimgrot(image,rotation)
%%
%%PARAMETER(S)
%%  image       index-matrix 
%%  rotation    rotation in deg, 90 180 or 270 
%%  matrix      RBG-matrix 
%% 
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003
function matrix= eimgrot (image,rotation)
  if (nargin ~= 2)
    eusage('matrix = eimgrot(image,rotation)');
  end
  rotation=rem(rotation,360);
  if rotation>=270
    matrix=flipud(image)';
  elseif rotation>=180
    matrix=flipud(fliplr(image));
  elseif rotation>=90
    matrix=flipud(image');
  else
    matrix=image;
  end
