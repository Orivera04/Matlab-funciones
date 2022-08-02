function [hline,hdots,hblots] = pltbrokenline(x,y,gap,linestyle);

% PLTBROKENLINE(X,Y,GAP) Plots points with dots and a line not joining
%   them. Similar to using the linestyle '.-' but there is a gap
%   between the  dots and the line. The size of the gap is GAP
%   (default=30).  
%
%   PLTBROKENLINE(X,Y,GAP,LINESTYLE) uses the specified line
%   style. Optional output arguments are:
%
%   [HLINE,HDOTS,HBLOTS] = PLTBROKENLINE(X,Y,GAP,LINESTYLE)
%   where HLINE = handle of line that (almost) joins the dots,
%         HDOTS = handle of the dots,
%         HBLOTS = handle of the invisible region around each dot.

if nargin<2
  y = x;
  x = 1:length(x);
end
if nargin<3
  gap = 30;
end
if nargin<4
  linestyle = '-';
end
held = ishold;
line_handle = plt(x,y,linestyle);
hold on
blot_handle = plt(x,y,'.');
if strcmp(get(gca,'color'),'none')
  blotcolour = get(gcf,'color');
else
  blotcolour = get(gca,'color');
end
set(blot_handle,'MarkerSize',gap,...
    'color',blotcolour)

dot_handle = plt(x,y,'.');


if ~held
  hold off
end

if nargout==1
  hline = line_handle;
end
if nargout==2
  hline = line_handle;
  hdots = dot_handle;
end
if nargout==3
  hline = line_handle;
  hdots = dot_handle;
  hblots = blot_handle;
end


