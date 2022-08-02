%%NAME
%%  edecipol  -   remove redundant polar coordinates of plot data
%%
%%SYNOPSIS
%%  [newAlpha newRadia]=edecipol(alphaData,radiaData[,minDelta])
%%
%%PARAMETER(S)
%%  alphaData       vector of alpha values in rad
%%  radiaData       vector of radia values
%%  minDelta        scalar, min. range delta, default=1
%%  newAlpha        vector of selected alpha values
%%  newRadia        vector of selected radia values
%% 
% written by stefan.mueller@fgan.de (C) 2007
function [newAlpha,newRadia]=edecipol(alphaData,radiaData,minDelta)

% test parameter
if nargin>3  | nargin<2
  eusage('[newAlpha newRadia]=edecipol(alphaData,radiaData[,minDelta])');
end
if nargin <3
  minDelta=1;
end
[xr xc]=size(alphaData);
if xr>2
  alphaData=alphaData';
  xc=xr;
end
[yr yc]=size(radiaData);
if yr>2
  radiaData=radiaData';
  yc=xr;
end
if xc~=yc
  error('size of alphaData <> size radiaData');
end
[dr dc]=size(minDelta);
if (dr+dc)>2
  error('minDelta should be scalar');
end

% get delta range
minDelta=minDelta*minDelta;
xData=cos(alphaData).*radiaData;
yData=sin(alphaData).*radiaData;
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
newAlpha=alphaData(idx);
newRadia=radiaData(idx);
