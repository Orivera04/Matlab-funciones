%%NAME
%%  ergbsplitt  - splitt RGB-matrix to red, green and blue matrix 
%%
%%SYNOPSIS
%%  [red,green,blue]=ergbsplitt(matrix)
%%
%%PARAMETER(S)
%%  matrix      RBG-matrix 
%%  red         red color part of matrix,min. value=0,max value=1
%%  green       green color part of matrix,min. value=0,max value=1
%%  blue        blue color part of matrix,min. value=0,max value=1
%% 
% written by stefan.mueller@fgan.de (C) 2007
function [red,green,blue]= ergbsplitt (matrix)
  if (nargin ~= 1) || (nargout ~= 3)
    eusage('[red,green,blue] = ergbsplitt(matrix)');
  end

  red=bitshift(matrix,-16);
  matrix=matrix-bitshift(red,16);
  green=bitshift(matrix,-8);
  blue=matrix-bitshift(green,8);
  green=green/255;
  red=red/255;
  blue=blue/255;
