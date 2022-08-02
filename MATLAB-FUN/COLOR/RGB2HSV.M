function H = rgb2hsv(M);
%RGB2HSV Red-green-blue to hue-saturation-value conversion.
%	H = RGB2HSV(M) converts an RGB color map to an HSV color map.
%	Each map is a matrix with any number of rows, exactly three columns,
%	and elements in the interval 0 to 1.  The columns of the input matrix,
%	M, represent intensity of red, blue and green, respectively.  The
%	columns of the resulting output matrix, H, represent hue, saturation
%	and color value, respectively.
%
%	See also HSV2RGB, COLORMAP, RGBPLOT. 

%	See Alvy Ray Smith, Color Gamut Transform Pairs, SIGGRAPH '78.
%	C. B. Moler, 8-17-86, 5-10-91, 2-2-92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

v = max(M')';
s = zeros(size(v));
h = zeros(size(v));
d = (v - min(M')');
k = find(v);
s(k) = d(k)./v(k);
z = ~d;
d = d + z;
r = M(:,1);
g = M(:,2);
b = M(:,3);
k = find(r == v);
h(k) = (g(k) - b(k))./d(k);
k = find(g == v);
h(k) = 2 + (b(k) - r(k))./d(k);
k = find(b == v);
h(k) = 4 + (r(k) - g(k))./d(k);
h = h/6;
k = find(h < 0);
h(k) = h(k) + 1;
h = (~z).*h;
H = [h s v];
