%%NAME
%%  eerrbar - get coordinates-matrix for errorbar-plotting
%%
%%SYNOPSIS
%%  [xeb yeb]=eerrbar(x,y,error[,barWidth])
%%
%%PARAMETER(S)
%%  
%%  x            vector of x-data
%%  y            vector of y-data
%%  barWidth     x-size of bars
%%               default: autosize
%%
%%  xeb          matrix of x errorbar-coodinates
%%  yeb          matrix of y errorbar-coodinates
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function [xeb,yeb]=eerrbar(x,y,error,barWidth)
  eglobpar
  if nargin>4 | nargin<3
    eusage('[xeb yeb]=eerrbar(x,y,error,barWidth)');
  end
  [r c]=size(x);
  if r>1
    x=x';
    c=r;
  end
  if nargin<4
    barWidth=min(x(2:c)-x(1:c-1))/3;
  end

  xeb=[x x-barWidth/2 x-barWidth/2;x x+barWidth/2 x+barWidth/2];

  [r c]=size(y);
  if r>1
    y=y';
  end

  [r c]=size(error);
  if r>1
    error=error';
  end
  ype=y+error;
  yme=y-error;
  yeb=[ype ype yme;yme ype yme];
