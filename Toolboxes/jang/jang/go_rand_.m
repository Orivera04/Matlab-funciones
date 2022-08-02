global OPT_METHOD	% optimization method
OPT_METHOD = 'simplex';	% this is used in peaksfcn.m 
global PREV_PT		% previous data point

var_n = 2;		% Number of input variables
range = [-3, 3; -3, 3];	% Range of the input variables
% Plot contours of peaks function
[x, y, z] = peaks;
pcolor(x,y,z); shading interp; hold on;
contour(x, y, z, 20, 'r');
hold off; colormap(gray);
colormap(flipud(colormap));	% flip colormap
axis square; xlabel('X'); ylabel('Y');
drawnow;

fcn = 'peaksfcn';

%delete(findobj(gcf, 'tag', 'currpt'));
PREV_PT = [];
x = randsrch(fcn, [2, -2], range);
line(x(1), x(2), 'linestyle', 'x', 'markersize', 10, ...
	'clipping', 'off', 'erase', 'none', ...
	'color', 'c', 'tag', 'member');

PREV_PT = [];
x = randsrch(fcn, [-1, -1], range);
line(x(1), x(2), 'linestyle', 'x', 'markersize', 10, ...
	'clipping', 'off', 'erase', 'none', ...
	'color', 'c', 'tag', 'member');

PREV_PT = [];
x = randsrch(fcn, [0, 1], range);
line(x(1), x(2), 'linestyle', 'x', 'markersize', 10, ...
	'clipping', 'off', 'erase', 'none', ...
	'color', 'c', 'tag', 'member');
