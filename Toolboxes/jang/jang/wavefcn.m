function y = wavefcn(x)

global count

y = sin(10*x)*sin(x);

line(x, y, 'linestyle', 'x', 'markersize', 20, ...
	'erase', 'xor', 'color', 'c', 'tag', 'individual');
text(x, y, num2str(count), 'fontsize', 20, 'tag', 'count', ...
	'erase', 'xor');

%line(x, y, 'linestyle', '.', 'markersize', 20, ...
%	'erase', 'xor', 'color', 'c', 'tag', 'individual');
drawnow;
