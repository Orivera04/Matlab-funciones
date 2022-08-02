function M = hsv2rgb(H)
%HSV2RGB Hue-saturation-value to red-green-blue conversion.
%	M = HSV2RGB(H) converts an HSV color map to an RGB color map.
%	Each map is a matrix with any number of rows, exactly three columns,
%	and elements in the interval 0 to 1.  The columns of the input matrix,
%	H, represent hue, saturation and value, respectively.  The columns of
%	the resulting output matrix, M, represent intensity of red, blue and
%	green, respectively.
%
%	As H(:,1), the hue, varies from 0 to 1, the resulting color varies
%	from red, through yellow, green, cyan, blue and magenta, back to red.
%	When H(:,2), the saturation, is 0, the colors are unsaturated; they
%	are simply shades of gray.  When H(:,2) is 1, the colors are fully
%	saturated; they contain no white component.  When H(:,3), the color
%	value, varies from 0 to 1, the brightness increases.
%
%	The default colormap, HSV, is hsv2rgb([h s v]) where
%	h is a linear ramp from 0 to 1 and both s and v are all 1's.
%
%	See also RGB2HSV, COLORMAP, RGBPLOT.

%	See Alvy Ray Smith, Color Gamut Transform Pairs, SIGGRAPH '78.
%	C. B. Moler, 8-17-86, 5-10-91, 2-2-92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

h = H(:,1);
s = H(:,2);
v = H(:,3);
h = 6*h(:);
k = fix(h-6*eps);
f = h-k;
t = 1-s;
n = 1-s.*f;
p = 1-(s.*(1-f));
e = ones(size(h));
r = (k==0).*e + (k==1).*n + (k==2).*t + (k==3).*t + (k==4).*p + (k==5).*e;
g = (k==0).*p + (k==1).*e + (k==2).*e + (k==3).*n + (k==4).*t + (k==5).*t;
b = (k==0).*t + (k==1).*t + (k==2).*p + (k==3).*1 + (k==4).*1 + (k==5).*n;
f = v./max([r(:);g(:);b(:)]);
M = [f.*r f.*g f.*b];
