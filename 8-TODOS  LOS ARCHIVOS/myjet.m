function J = myjet(m)
%function J = myjet(m)
%MYJET: Variant of 
%{
%JET	Variant of HSV.
%	JET(M), a variant of HSV(M), is the colormap used with the
%	NCSA fluid jet image.
%	JET, by itself, is the same length as the current colormap.
%	Use COLORMAP(JET).
%
%	See also HSV, HOT, PINK, FLAG, COLORMAP, RGBPLOT.

%	C. B. Moler, 5-10-91, 8-19-92.
%	Copyright (c) 1984-92 by The MathWorks, Inc.
%}
%					A. Knight, Nov, 1992

if nargin < 1, m = size(get(gcf,'colormap'),1); end
n = max(round(m/5),1);
ramp = (1:n)'/n;
o = ones(size(ramp));
z = zeros(size(ramp));
r = [z;    z;    ramp;         o;            o;    1];
g = [z;    ramp; o;            flipud(ramp); ramp; 1];
b = [ramp; o;    flipud(ramp); z;            ramp; 1];
J = [r g b];
while size(J,1) > m
   J(1,:) = [];
   if size(J,1) > m, J(size(J,1),:) = []; end
end
