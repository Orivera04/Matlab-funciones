function mouseclickext(h)

ClickType = get(h.fig, 'SelectionType');
% CurChar = get(h.fig, 'CurrentCharacter');
% set(h.fig, 'CurrentCharacter', '0');
% get position in axix
pos = get(gca, 'CurrentPoint');
ylim = get(gca, 'YLim');

% get previous save x-location on axes (see creation of figure in pw.m)
xloc = get( h.fig, 'UserData');

if strcmp(ClickType, 'normal') % && strcmp(lower(CurChar), 's')
    set(h.v1, 'XData', [pos(1) pos(1)], 'YData', ylim );
    set( h.fig, 'UserData', [ min( max(1, pos(1)), 1000*h.ns/h.fs ) xloc(2)]);
elseif strcmp(ClickType, 'alt') % && strcmp(lower(CurChar), 's')
    set(h.v2, 'XData', [pos(1) pos(1)], 'YData', ylim );
    set( h.fig, 'UserData', [xloc(1) min( max(1, pos(1)), 1000*h.ns/h.fs ) ]);
end





