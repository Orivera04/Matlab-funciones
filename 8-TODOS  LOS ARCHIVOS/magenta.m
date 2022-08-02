function b = magneta(m)
 
if nargin < 1, m = size(get(gcf,'colormap'),1); end
b = [linspace(0,1,m)'*[1 0 1]];
 
