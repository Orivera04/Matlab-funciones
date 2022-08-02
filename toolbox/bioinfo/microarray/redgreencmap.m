function p = redgreencmap(m)
%REDGREENCMAP creates a red and green colormap.
%
%   REDGREENCMAP(M) returns an M-by-3 matrix containing a red and green
%   colormap. Low values are bright green, values in the center of the map
%   are blac,k and high values are red.
%
%   REDGREENCMAP, by itself, is the same length as the current colormap.
%
%   For example, to reset the colormap of the current figure, type
%
%             colormap(redgreencmap)
%
%   See also CLUSTERGRAM, COLORMAP, COLORMAPEDITOR.

%   Copyright 2003-2004 The MathWorks, Inc. 
%   $Revision: 1.3.4.2 $  $Date: 2004/01/24 09:19:14 $

if nargin < 1, m = size(get(gcf,'colormap'),1); end
coloredLength = floor((m-1)/2);

% deal with small inputs in a consistent way
if m < 3
    if m == 0
        p = zeros(0,3);
    elseif m == 1
        p = zeros(1,3);
    else
        p = [0 1 0; 1 0 0];
    end
    return
end

linearCol = 1/(coloredLength):1/(coloredLength):1;

% red and blue are at low intensity in the green half
lowintensity = .1*sin(0:pi/(coloredLength):(pi-(pi/coloredLength)));

if coloredLength == ((m-1)/2)
    fillerZeros = 0;
else
   fillerZeros = [0 0]; 
end

% red is linear for red half
red = [lowintensity fillerZeros linearCol];
% green is opposite of red
green = fliplr(red);
% blue is lowintensity for red half
blue = [lowintensity fillerZeros fliplr(lowintensity)];
p = [red',green',blue'];
