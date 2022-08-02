function figH = genfig(figTitle)

%GENFIG	Generates a figure window.
%	GENFIG(FIG_TITLE) generates a figure windows with FIG_TITLE
%	as its title. If a figure windows with the same title exists,
%	make the figure window as the current window.

%	Roger Jang, 5-26-95

if ~isstr(figTitle)
	error('Given figure title much be a string.')
end
figH = findobj(0, 'name', figTitle);
if isempty(figH),
	figH = figure('name', figTitle, 'number', 'off');
else
	set(0, 'currentfig', figH);
end
