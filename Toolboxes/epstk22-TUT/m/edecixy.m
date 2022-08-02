%%NAME
%%  edecixy  -   remove redundant coordinates of plot data
%%
%%SYNOPSIS
%%  [newX newY]=edecixy(xData,yData[,minDelta])
%%
%%PARAMETER(S)
%%  xData           vector of x values
%%  yData           vector of y values
%%  minDelta        scalar, min. range delta, default=1
%%  newX            vector of selected x values
%%  newY            vector of selected y values
%% 
% written by stefan.mueller@fgan.de (C) 2007
function [xd,yd]=edecixy(xData,yData,minDelta)

% test parameter
if nargin>3  | nargin<2
  eusage('[newX newY]=edecixy(xData,yData[,minDelta])');
end
if nargin <3
  minDelta=1;
end
[xr xc]=size(xData);
if xr>2
  xData=xData';
  xc=xr;
end
[yr yc]=size(yData);
if yr>2
  yData=yData';
  yc=xr;
end
if xc~=yc
  error('size of xData <> size yData');
end
[dr dc]=size(minDelta);
if (dr+dc)>2
  error('minDelta should be scalar');
end

% get delta range
minDelta=minDelta*minDelta;
dx=xData(2:xc)-xData(1:xc-1);
dy=yData(2:yc)-yData(1:yc-1);
dxy=dx.*dx+dy.*dy;

% select coordinates
t=0;
idx=1;
for i=1:xc-1
  t=t+dxy(i);
  if t>minDelta
    idx=[idx i+1];
    t=0;
  end
end
xd=xData(idx);
yd=yData(idx);
