% PREVIEWVFIELD Provides an easy preview of the vector field using LIC
% method. It automatically resizes the vector field to a convenient size.
% [PREVIEW,ZOOMFACTOR] = PREVIEWVFIELD(VX, VY, COLORMAP, MAXDIMENSION);
% Usage:
% PREVIEW returns the generated colored LIC image.
% 
% ZOOMFACTOR returns the zoom factor being used.
% 
% VX and VY should contain X and Y components of the vector field. They
% should be M x N floating point arrays with equal sizes.
% 
% COLORMAP is a standard matlab colormap array (an M-by-3 matrix) used by this function to
% convert scalar values to colors.
% 
% MAXDIMENSION is the largest preview image dimension. Field is resized in
% a manner that the largest dimension of the output image will be MAXDIMENSION.
% 
% Example:
% previewvfield(vx,vy);

function [preview,zoomFactor] = previewvfield(vx,vy, ColorMap, maxDimension);
if nargin < 4
    maxDimension = 500;
end;

if nargin < 3
    ColorMap = jet; % Default colormap
end;

[width,height] = size(vx);
zoomFactor = maxDimension / max([width,height]);
preview = plotvfield(vx,vy,zoomFactor,1, ColorMap);
