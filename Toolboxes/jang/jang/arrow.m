function h = arrow(x, y, s, style)
%ARROW Use arrows to plot curves.
%	LINE_HANDLE = ARROW(X, Y, S, STYLE)
%	S (0.2 by default) is the scale of the arrow head;
%	STYLE ('-' by default) is the line style of the arrow;
%	LINE_HANDLE is the handle of the arrow.

% J.-S. Roger Jang, 1993

if nargin <= 2, s = 0.2; end
if nargin <= 3, style = '-'; end

xx = [0 1 1-s 1 1-s].';
yy = [0 0 s/2 0 -s/2].';
arrow = xx + yy.*sqrt(-1);

x=x(:);
y=y(:);
z = x + y*sqrt(-1);
a = arrow*diff(z).'+ones(5,1)*z(1:length(z)-1).';
h = plot(real(a), imag(a), style);
