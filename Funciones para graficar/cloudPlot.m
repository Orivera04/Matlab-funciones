function [ varargout ] = cloudPlot( X, Y, axisLimits, useLogScale )
%CLOUDPLOT Does a cloud plot of the data in X and Y.
% CLOUDPLOT(X,Y) draws a cloudplot of Y versus X. A cloudplot is in essence
% a 2 dimensional histogram showing the density distribution of the data
% described by X and Y. As the plot displays density information, the
% dimensionality of X and Y are ignored. The only requirement is that X and
% Y have the same number of elements. Cloudplot is written to visualize
% large quantities of data and is most appropriate for datasets of 10000
% elements or more.
%
% CLOUDPLOT is fully compatible with SUBPLOT, COLORBAR and COLORMAP, but
% does not handle zoom or rescaling of the axis in any way. Hold states are
% also ignored.
%
% CLOUTPLOT(X,Y,axisLimits) plots the values of X and Y that are within the
% limits specified by axisLimits. axisLimits is a 4-element vector with the
% same meaning as "axis( axisLimits )" would have on a regular plot.
% axisLimits can be [] in which case it will be ignored.
%
% CLOUTPLOT(X,Y,axisLimits,useLogScale) If useLogScale == true, plots the
% base10 logarithm of the density at each point. Useful for distributions
% where the density varies greatly. 
%
% h = CLOUTPLOT(...) returns the handle to the cloud image in h.
%
% Example:
%   cloudPlot( randn(10000,1), randn(10000,1) );
%    Will plot a Gaussian scattered distribution.
%
%   cloudPlot( randn(1000), randn(1000), [0 3 -1 4]);
%    Will plot a Gaussian scattered distribution of X and Y values within
%    the limits.

% Check the data size
assert ( numel(X) == numel(Y), ...
    'The number of elements in X and Y must be the same.' );

if ( nargin >= 3 && ~isempty(axisLimits) )
    pointSelect = X<=axisLimits(2) & X>=axisLimits(1) & ...
        Y<=axisLimits(4) & Y>=axisLimits(3);
    X = X(pointSelect);
    Y = Y(pointSelect);
end

if ( nargin < 4 )
    useLogScale = false;
end

%Remove any nans or Infs in the data as they have no meaning in this
%context.
pointSelect = isinf(X) | isnan(X) | isinf(Y) | isnan(Y);
X = X(~pointSelect);
Y = Y(~pointSelect);
    

% Plot to get appropriate limits
h = plot ( X(:), Y(:), '.' );
g = get( h, 'Parent' );
xLim = get(g, 'Xlim' );
yLim = get(g, 'Ylim' );
xTick = get(g, 'XTick' );
xTickLabel = get(g, 'XTickLabel' );
yTick = get(g, 'YTick' );
yTickLabel = get(g, 'YTickLabel' );

%Get the bin size.
unitType = get(g,'Unit');
set(g,'Unit','Pixels')
axesPos = get(g,'Position');
nHorizontalBins = axesPos(3);
nVerticalBins = axesPos(4);
set(g,'Unit', unitType );

% Allocate an area to draw on
bins = ceil([nHorizontalBins nVerticalBins ]);
binSize(2) = diff(yLim)./(bins(2));
binSize(1) = diff(xLim)./(bins(1));

canvas = zeros(bins);

% Draw in the canvas
xBinIndex = floor((X - xLim(1))/binSize(1))+1;
yBinIndex = floor((Y - yLim(1))/binSize(2))+1;
try
    for i = 1:numel(xBinIndex);
        canvas(xBinIndex(i),yBinIndex(i)) = ...
            canvas(xBinIndex(i),yBinIndex(i)) + 1;
    end
catch ME %#ok
    disp ( [xBinIndex(i) yBinIndex(i)] )
    disp ( bins );
    disp ( '--' );
end

% Show the canvas and adjust the grids.
if ( useLogScale )
    h = imagesc ( log10(canvas') );
else
    h = imagesc ( canvas' );
end

axis ( 'xy' );
g = get( h, 'Parent' );
xTickAdjust = (xTick - min(xTick))*bins(1)/(max(xTick)-min(xTick))+0.5;
yTickAdjust = (yTick - min(yTick))*bins(2)/(max(yTick)-min(yTick))+0.5;
set ( g, 'XTick', xTickAdjust );
set ( g, 'XTickLabel', xTickLabel );
set ( g, 'YTick', yTickAdjust );
set ( g, 'YTickLabel', yTickLabel );

% Optionally return a handle
if ( nargout > 0 )
    varargout{1} = h;
end





