function b = green(m)
 
if nargin < 1, m = size(get(gcf,'colormap'),1); end
b = [zeros(m,1) linspace(0,1,m)' zeros(m,1)];
 
