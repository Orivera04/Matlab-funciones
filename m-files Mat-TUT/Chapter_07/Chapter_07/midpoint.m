% This program finds the midpoint of a line segment
 
[x1, y1] = entercoords('first');
[x2, y2] = entercoords('second');
 
midx = findmid(x1,x2);
midy = findmid(y1,y2);
 
fprintf('The midpoint is (%.1f, %.1f)\n',midx,midy)
