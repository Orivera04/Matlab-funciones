function plotzero(linestyle)

%PLOTZERO(linestyle) To plot a set of axes at the current zero position.

%
%                   Andrew Knight, Oct, 1992
%
if nargin == 0
  linestyle = '-';
end
ax = axis;
holdstate = ishold;
if ~ishold
   hold on
end

bgcolour = get(gcf,'color');
if bgcolour==[0.5 0.5 0.5]
   colour = rand(1,3);
else
   colour = 1 - bgcolour;
end
h = plot([ax(1) 0;ax(2) 0],[0 ax(3);0 ax(4)]);
set(h,'color',colour,'linestyle',linestyle)
axis(ax)

% Restore old hold state

if holdstate==0
   hold off
end

