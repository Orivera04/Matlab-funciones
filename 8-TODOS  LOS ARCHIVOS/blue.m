function b = blue(m)
 
if nargin < 1, m = size(get(gcf,'colormap'),1); end
b = [ zeros(m,2) linspace(0,1,m)'];
 
