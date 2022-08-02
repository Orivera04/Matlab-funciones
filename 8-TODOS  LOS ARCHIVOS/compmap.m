function compmap(strfun,xmin,xmax,ymin,ymax)
% This function maps a mesh of lines parallel
% to the coordinate axes in the complex plane
% into the image of the rectangular mesh under
% the function defined by strfun, a character
% string specifing the function.

fun=fcnchk(strfun,'vectorized');
dx=(xmax-xmin)/15;
dy=(ymax-ymin)/15;
v=linspace(ymin,ymax,100);
h=linspace(xmin,xmax,100);

%First map the vertical lines
for x=xmin:dx:xmax
  mapvert=fun(x+v*i);
  plot(mapvert); hold on;
end

%Now map the horizontal lines
for y=ymin:dy:ymax
  maphoriz=fun(h+y*i);
  plot(maphoriz)
end

axis equal;
hold off;
