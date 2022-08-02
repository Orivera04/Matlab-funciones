function lineH = cyclesty(H)
%Cyclesty Cycle line styles.
%	CYCLESTY(HANDLE) cycles line styles under H, which is either
%	a axes or figure.  If no argument is given, H is taken as the
%	current figure.

%	Roger Jang, 5-26-95

if nargin == 0,
	H = gcf;
end

line_style = str2mat('-', '--', ':', '-.');
type = get(H, 'type');

if strcmp(type, 'figure'),
	axesH = findobj(H, 'type', 'axes');
	axes_n = length(axesH);
	for i = 1:axes_n,
		lineH = findobj(axesH(i), 'type', 'line');
		lineH = flipud(lineH);
		line_n = length(lineH);
		for i=1:line_n,
			set(lineH(i), 'LineStyle', ...
			deblank(line_style(rem(i-1, size(line_style, 1))+1, :)));
		end
	end
elseif strcmp(type, 'axes')
	lineH = findobj(H, 'type', 'line');
	lineH = flipud(lineH);
	line_n = length(lineH);
	for i=1:line_n,
		set(lineH(i), 'LineStyle', ...
		deblank(line_style(rem(i-1, size(line_style, 1))+1, :)));
	end
end
