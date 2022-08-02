function smotion(x,y,titl)
%
% smotion(x,y,titl)
% ~~~~~~~~~~~~~~~~~
% This function animates the string motion.
%
% x    - a vector of position values along the
%        string
% y    - a matrix of transverse deflection 
%        values where successive rows give
%        deflections at successive times
% titl - a title shown on the plot (optional)
%
% User m functions required: none
%----------------------------------------------

if nargin < 3, titl=' '; end
xmin=min(x); xmax=max(x);
ymin=min(y(:)); ymax=max(y(:));
[nt,nx]=size(y); clf reset; 
for j=1:nt
  plot(x,y(j,:),'k');
  axis([xmin,xmax,2*ymin,2*ymax]);
  axis('off'); title(titl);
  drawnow; figure(gcf); pause(.1)
end