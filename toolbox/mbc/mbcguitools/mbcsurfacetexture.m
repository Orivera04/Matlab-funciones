function texturemap = mbcsurfacetexture(data,constraints,multiplier,cmap,range)
%MBCSURFACETEXTURE
%
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $

if nargin<5 | isempty(range)
    tempdata = data;
    if ~isempty(constraints)
        % remove points outside boundary
        tempdata(constraints>=0) = NaN;
    end
    % calculate the upper and lower limits of the model data
    % for which we will be showing colours
    range = [ min(tempdata(isfinite(tempdata(:)))) max(tempdata(isfinite(tempdata(:)))) ];
    if isempty(range)
        texturemap = zeros([size(tempdata),3]);
        return;
    end
end

if isempty(constraints)
    texturemap = i_NoBoundary(data,cmap,multiplier,range);
else
    texturemap = i_WithBoundary(data,constraints,cmap,multiplier,range);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cdata = i_WithBoundary(data,constraints,cmap,multiplier,range)

ln = size(cmap,1);
linrange = linspace(range(1),range(2),ln-1);
linrange(1) = -Inf;
linrange(end) = Inf;

if multiplier>0
    constraints = interp2(constraints, multiplier );
    data = interp2(data, multiplier);
end

data(constraints>=0) = NaN;

% The values in "cdata" identify where in the range each point in "data" lies.
[q,cdata] = histc(data,linrange); % NaN will produce index zero
cdata = cdata + 1;

sz = size(cdata);
cdata = cmap(cdata,:);
cdata = reshape(cdata,[sz 3]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cdata = i_NoBoundary(data,cmap,multiplier,range)

ln = size(cmap,1);
linrange = linspace(range(1),range(2),ln-1);
linrange(1) = -Inf;
linrange(end) = Inf;
% The values in "cdata" identify where in the range each point in "data" lies.
[q,cdata] = histc(data,linrange); % NaN will produce index zero
cdata = cdata + 1;

if multiplier>0
    cdata = interp2(cdata, multiplier);
    cdata = floor(cdata);
end
sz = size(cdata);
cdata = cmap(cdata(:),:);
cdata = reshape(cdata,[sz 3]);


