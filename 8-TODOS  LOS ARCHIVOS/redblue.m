function m = redblue(n)
 
if nargin < 1
  n = size(get(gcf,'colormap'),1); 
end

x = linspace(0,1,n);
redx = [0 .5 linspace(.5 + eps,1,100)];
redy = [.35 .78 fitrange(linspace(0,1).^6,.78,.85)];
red = interp1(redx,redy,x);

greenx = [0 .5 1];
greeny = [.5 .78 .35];
green = interp1(greenx,greeny,x);

bluex = [linspace(0,.5 - eps,100) .5 1];
bluey = [fitrange(-linspace(1,0).^6,.71,.78) .78 .3];
blue = interp1(bluex,bluey,x);

m =   [red' green' blue'];
 
