function h = value2hue(x)
c = colormap;
hsvcolor = rgb2hsv( c (round( x * length(c)), 1:3));
h = hsvcolor(1,1);