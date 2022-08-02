function m = bluewhite(n)
 
if nargin < 1
  n = size(get(gcf,'colormap'),1); 
end
non2 = floor(n/2);



% Testscript:
% subplot 221,imagesc(1:64),colormap(blueyellow),subplot 222,imagesc(peaks),subplot 223,rgbplot(blueyellow),axis([0 64 0 1])

x = linspace(0,1,n);

% Interpolate to a set of control points

xcontrol = linspace(0,1,5);
ycontrol = [.425 .45 .5 .7 1];
red = interp1(xcontrol,ycontrol,x);

xcontrol = linspace(0,1,5);
ycontrol = [.425 .45 .5 .7 1];
green = interp1(xcontrol,ycontrol,x);

xcontrol = linspace(0,1,5);
ycontrol = linspace(.6,1,5);
blue = interp1(xcontrol,ycontrol,x);

m =   [red' green' blue'];
