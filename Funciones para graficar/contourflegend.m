function axhandle = contourflegend(conts,h)

% Put a legend on a contourf plot.
% CONTOURFLEGEND(C,H) where C is the contour matrix as described in CONTOURC
% and used by CLABEL, and H is column vector of patch handles output by
% contourf. 
%
% Example:
% [c,h] = contourf(peaks);
% contourflegend(c,h)


% Andrew Knight, March 1998

indleft = 1;
indright = 0;
ind = [];
levels = [];
while indright<length(conts)
  indleft = indleft + length(ind) + 1;
  indright = indright + conts(2,indright+1) + 1;
  ind = indleft:indright;
  levels = [levels conts(1,indleft - 1)];
end   
levels = unique(levels);
%levels(length(levels)) = [];

%Get colours from the list of patch handles:
cindeces = zeros(1,length(h));
for i=1:length(h)
  cindeces(i) = get(h(i),'cdata');
end
cindeces = round(fitrange(unique(cindeces),1,length(colormap)));
map = colormap;
ind = find(isnan(cindeces));

% Sometimes not all the contours that cover the data range are drawn (for 
% example when the levels are specified manually).  In this situation the
% colour is NaN: we want to add a NaN colour in this case.

if ~isempty(ind)
  cindeces(ind) = [];
end
colours = map(cindeces,:);
if ~isempty(ind)
  colours(ind,:) = NaN;
end


% Now start drawing the legend.
contpos = get(gca,'pos');
contax = gca;

% The levels appearing on the legend must somehow include the extremes of
% the data where the colour represents anything higher (or lower) than
% the extreme contour.  For these we append the next level using the
% existing delta.

% Contourf seems to have been modified such that the data minimum is now
% included as a level. We delete that level and add the next step below
% and above:

dlevels = levels(end) - levels(end-1);
%if ~any(isnan(colours))
%  levels = [levels(1)-dlevels levels levels(end)+dlevels];
%else
%  levels = [levels levels(end)+dlevels];
%end
levels(1) = [];
levels = [levels(1)-dlevels levels levels(end)+dlevels];

%legpos(1) = contpos(1) + contpos(3) +contpos(3)/50;
legpos(1) = contpos(1) + contpos(3) + contpos(3)/200;
legpos(2) = contpos(2) + contpos(4)/2;
legpos(3) = contpos(3)/30;
legpos(4) = contpos(4)/2;
hcbar = axes('pos',legpos,...
    'yax','right',...
    'xtick',[],...
    'YLim',[levels(1) levels(length(levels))],...
    'YTick',levels,...
    'tickdir','out');
hold on
% Draw little rectangles for each colour used in the contour plot:
for i=1:length(levels)-1
  x = [0 1 1 0];
  y = levels([i i i+1 i+1]);
  if isnan(colours(i,:))
    patchhandle = patch(x,y,'r');
    set(patchhandle,'facecolor','none')
  else
    patch(x,y,colours(i,:))
  end
end

set(gcf,'CurrentAxes',contax)

if nargout>0
  axhandle = hcbar;
end

