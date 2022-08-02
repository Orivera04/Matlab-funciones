function pltlight

% Plot a dot at the position of the light(s)

% A. Knight December 1997

% Delete any existing light markers:
delete(findobj('Tag','MyLightMarker'))

h = findobj('type','light');
hold on
for i=1:length(h)
  pos = get(h(i),'pos');
  col = get(h(i),'color');
  hdot = patch(pos(1),pos(2),pos(3),'y',...
      'Marker','o',...
      'Markersize',10,...
      'MarkerEdgecolor','k',...
      'MarkerFaceColor',col,...
      'Tag','MyLightMarker');
end

  