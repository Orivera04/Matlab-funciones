function scrollplot(dx, varargin)
% scrollplot	Linear plot with multiple subplot and horizontal scrollbar
%
% scrollplot(dx, x1, y1)
% scrollplot(dx, x1, y1, x2, y2, ...)
% 			Plots every yn versus xn in a subplot. All subplots have common x limits.
%			The user can horizontally scroll the view using a scrollbar. The horizontal
%			view size is dx. If yn is a row or a column the n-th subplot is a line. 
%			If yn is a matrix each column is a line in the n-th subplot.
%
dxmem = 15; % how many times the size of the data sent to the plot is, with respect to the shown part
if dx > 0 % this means that the function has been called by the user and not by the function itself
	hf = figure;
	data = guidata(hf);
	data.Param = varargin;
	data.dx = dx;
	numsubplots = length(data.Param) / 2;
	xmax = -inf;
	xmin = +inf;
	for sp = 1 : numsubplots
		x = data.Param{sp * 2 - 1};
		y = data.Param{sp * 2};
		xmax = max(xmax, max(x));
		xmin = min(xmin, min(x));
	end
	data.xmin = xmin;
	data.xmax = max(xmax, xmin + dx);
	center = xmin;
else
	hf = varargin{1};
	data = guidata(hf);
	center = varargin{2};
	if (center > data.BeginMem) & (center + data.dx < data.EndMem)
		h = findobj(hf, 'Type', 'axes');
		for i = 1 : size(h, 1)
			set(h(i), 'xlim', center + [0 data.dx]);
		end
		return;
	end	
	numsubplots = length(data.Param) / 2;
end

beginmem = center - fix(dxmem / 2) * data.dx;
beginmem = max(beginmem, data.xmin);
endmem = beginmem + dxmem * data.dx;
endmem = min(endmem, data.xmax);
data.BeginMem = beginmem;
data.EndMem = endmem;
for sp = 1 : numsubplots
	h = subplot(numsubplots, 1, sp);
	x = data.Param{sp * 2 - 1};
	y = data.Param{sp * 2};
   % must be row-vectors
   if size(x,1) > size(x,2)
      x = x';
   end
   if size(y,1) > size(y,2)
      y = y';
   end
	beginind = 1;
	endind = size(x, 2);
	beginind = fix(fminbnd(inline('abs(m(fix(x))-xx)', 'x', 'm', 'xx'), 1, size(x, 2), optimset('TolX', 1), x, data.BeginMem)) - 1;
	beginind = max(1, beginind);
	endind = ceil(fminbnd(inline('abs(m(fix(x))-xx)', 'x', 'm', 'xx'), 1, size(x, 2), optimset('TolX', 1), x, data.EndMem)) + 1;
	endind = min(endind, size(x, 2));
	plot(x(beginind : endind), y(:,beginind : endind));
	set(h,'xlim',[center (center + data.dx)]);
	set(h,'ylim',[min(min(y)) max(max(y))]);
end
guidata(hf, data);

if dx > 0 % this means that the function has been called by the user and not by the function itself
	stepratio = .1;
	set(gcf,'doublebuffer','on');
	pos = get(h,'position');
	pos = [pos(1) pos(2)-0.1 pos(3) 0.05];
	if (data.xmax - data.xmin - dx) > 0
		steptrough = dx / (data.xmax - data.xmin - dx);
		steparrow = stepratio * steptrough;
		h = uicontrol('style', 'slider', ...
			'units', 'normalized', 'position', pos, ...
			'callback', 'scrollplot(0, gcf, get(gcbo,''value''));', ...
			'min', data.xmin, 'max', data.xmax - dx, 'value', data.xmin, 'sliderstep', [steparrow steptrough]);
	end
end