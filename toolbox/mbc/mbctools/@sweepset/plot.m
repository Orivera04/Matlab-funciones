function varargout = plot(X,varargin)
%PLOT Overloaded plot for sweepsets
%
% Sweepsets should be used in first 2 input arguments
%  e.g. plot(X,Y, ...)
% All other input arguments are passed to the built-in plot command with the 
% exeception of :
%   1) 'BD' which causes the bad data to be plotted.
%   2) 'REORDER' which causes the plotted data to be sorted on the X variable
%   3) 'CODE' which causes all the variables to be coded between 0 and 1
%   4) 'SWEEPLINES' which causes vertical lines at the sweep boundarys to be drawn
% An xlabel and a title are produced if X and Y have only one variable each.
% Otherwise a legend is produced.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.6 $  $Date: 2004/04/20 23:19:08 $

vars= varargin;
delarg=[];
flags = struct('BDFLAG',false,...
    'REORDER',false,...
    'CODE',false,...
    'SWEEPLINES',false,...
    'FORCESWEEPLINES',false,...
    'LEGEND',true,...
    'GRID','off',...
    'LINESTYLE','none',...
    'MARKER','o');

h2=[];
l=[];
AxHand=[];
for i = 1:length(vars)
	switch class(vars{i})
	case 'sweepset'
		vars{i}= vars{i}.data;
	case 'char'
		switch lower(vars{i})
		case 'bd'
			delarg=[delarg i];
			flags.BDFLAG = true;
		case 'reorder'
			delarg=[delarg i i+1];
			flags.REORDER = strcmp(lower(vars{i+1}), 'on');
		case 'code'
			delarg=[delarg i];
			flags.CODE = true;
		case 'sweeplines'
			delarg=[delarg i i+1];
			flags.SWEEPLINES = true;
			style = vars{i+1};
            if isletter(style(1))
                flags.sweeplinecolor = style(1);
                flags.sweeplinestyle = style(2:end);
            else
                flags.sweeplinecolor = [];
                flags.sweeplinestyle = style;
            end            
        case 'forcesweeplines'
            delarg = [delarg i];
            flags.FORCESWEEPLINES = true;
		case 'legend'
			delarg=[delarg i i+1];
			flags.LEGEND = strcmp(lower(vars{i+1}), 'on');
		case 'parent'
			AxHand= vars{i+1};
        case 'plotproperties'
			delarg=[delarg i i+1];
            props = vars{i+1};
            if isstruct(props)
                flags.LEGEND = strcmp(lower(props.showLegend), 'on');
                flags.REORDER = strcmp(lower(props.reorderData), 'on');
                flags.BDFLAG = strcmp(lower(props.showBadData), 'on');
                flags.GRID = props.showGrid;
                flags.LINESTYLE = props.dataLineStyle;
                flags.MARKER = props.dataMarker;
            end
		end
	end
end

vars(delarg)=[];

if isempty(AxHand)
	AxHand=gca;
end

visibleState  = get(AxHand,'visible');
if nargin > 1 && isa(varargin{1},'sweepset')
	Y= varargin{1};
	if isa(X,'sweepset')
		% If X is a sweepset then X.data will contain NaN's as well as Y
		% This needs to be rectified before plotting so create a dummy variable
		% with the correct data
		x = X.data;
        baddata = X.baddata; % this is need to fix problem with indexing into sparse array
		x(isnan(x)) = baddata(isnan(x));
		[h, h2, sl] = i_doPlot(AxHand, x, Y, vars(2:end), flags);
		lab = X.var.name;
		if ~isempty(char(X.var.units))
			lab = [lab ' [',char(X.var.units),']'];
		end
		set(get(AxHand,'xlabel'),'string',lab,'Interpreter','none');
	else
		[h, h2, sl] = i_doPlot(AxHand, X, Y, vars(2:end), flags);
	end
else
	Y = X;
	X = 1:size(Y.data,1);
	[h, h2, sl] = i_doPlot(AxHand, X, Y, vars, flags);
end
% Haw many variables
s2 = min(Y.nvar, length(h));
% Tag the sweeplines if there are enough handles
set(h(1:s2),'Tag','SweepLines');
set(sl, 'Tag', 'TestDelimiters');
hands = [h(1:s2);h2;sl];

if s2 == 1
	if isempty(char(Y.var.units))
		lab=Y.var.name;
	else
		lab=[Y.var.name,' [',char(Y.var.units),']'];
	end
	set(get(AxHand,'title'),'string',lab,'FontWeight','bold','Interpreter','none');
end

% Draw the legend if required
if (s2 > 1 || flags.SWEEPLINES) && flags.LEGEND
	labels = cell(length(h),1);
	for n = 1:s2
        str_unit = char(Y.var(n).units);
        if isempty(str_unit)
            labels{n} = Y.var(n).name;
        else
            labels{n} = [Y.var(n).name, ' [', str_unit , ']'];
        end
    end
	if flags.BDFLAG && any(isnan(Y.data(:)))
		j = 1;
		for n = 1:s2 
			if any(isnan(Y.data(:,n)))
                str_unit = char(Y.var(n).units);
				if isempty(str_unit)
					labels{s2+j}=['Bad Data ' Y.var(n).name];
				else
					labels{s2+j}=['Bad Data ' Y.var(n).name, ' [', str_unit, ']'];
				end
				j = j+1;
			end
		end
	end
	if ~isempty(sl)
		labels{end+1} = 'New test';
    end
    l = mbcgraph.legend(hands, labels, ...
        'Interpreter', 'none', ...
        'MoveMode', 'boundtoaxes');
end
set(AxHand, 'visible', visibleState);

% Set the requested grid state
grid(AxHand, flags.GRID);

if nargout>0
    varargout{1} = h;
    varargout{2} = l;
    varargout{3} = AxHand;
end



function [h, h2, sl] = i_doPlot(AxHand, X, Y, vars, flags)
% Get the current hold state of the axes
% nextPlotState = get(AxHand,'NextPlot');
% Have we been asked to reorder the X data?
index = 1:length(X);
if flags.REORDER
	[unused, index] = sort(X);
end
if flags.CODE
	minY = min(Y.data);
	range = max(Y.data) - minY;
	% Ensure no division by zero errors in the coding
	range(range == 0) = inf;
	% Create variables the same size as the data
	range = repmat(range, size(Y.data, 1), 1);
	minY = repmat(minY, size(Y.data, 1), 1);
	Y.data = (Y.data - minY) ./ range;
	bd = isbad(Y);
	Y.baddata(bd) = (Y.baddata(bd) - minY(bd)) ./ range(bd);
end
% Plot the good data
h2 = [];
h  = [];
sl = [];
if ~isempty(Y)
	h = plot(X(index), Y.data(index,:), ...
        vars{:}, ...
        'parent', AxHand, ...
        'linestyle', flags.LINESTYLE, ...
        'marker', flags.MARKER);
    % The fact that the data has been reordered is important for other
    % users - if they care then they can check to see if this has created a
    % dataReordered property.
    if flags.REORDER
        uddH = handle(h);
        for k = 1:numel(uddH)
            schema.prop(uddH(k), 'OriginalXDataIndex', 'MATLAB array');
        end
        [dummy, reorderIndex] = sort(index);
        set(uddH, 'OriginalXDataIndex', reorderIndex);
    end
	% Have we been asked to plot bad data
	if flags.BDFLAG && any(any(isnan(Y.data)))
		% Iterate through the variables in turn
		for i = 1:size(Y.data, 2)
			% Find the bad data
			bdind = isnan(Y.data(:,i));
			if any(bdind)
				% If there is some bad data then plot it (Note that bad
				% data is held in the Y variable, X must contain all the data)
				h2(i, 1) = line(X(bdind), Y.baddata(bdind, i), ...
                    'Marker', 'x',...
                    'LineStyle', 'none',...
					'color', get(h(i), 'color'),...
					'linewidth', 2,...
					'markersize', 8,...
					'parent', AxHand);
			end
		end
	end
end
% Have we been asked to plot the sweeplines and do we have a dataset which
% isn't one test per record
sizeY = size(Y);
if flags.SWEEPLINES && ~flags.REORDER && (~isequal(sizeY(1), sizeY(3)) || flags.FORCESWEEPLINES)
    % Get the starting positions of the sweeps
    t = [1 tstart(Y)+tsizes(Y)];
    io = ones(size(t));
    ylim = get(AxHand, 'ylim');
    % Make the halfway X points
    halfX = mean([X(1:end-1) ; X(2:end)]);
    halfX = [X(1) halfX  X(end)];
    ix = [halfX(t); halfX(t); halfX(t)];
    iy = [ylim(1)*io; ylim(2)*io; NaN*io];
    % Plot the sweep lines
    sl = line(ix(:), iy(:), ...
        'parent', AxHand);
    if ~isempty(flags.sweeplinestyle)
        set(sl, 'linestyle', flags.sweeplinestyle);
    end
    if ~isempty(flags.sweeplinecolor)
        set(sl, 'color', flags.sweeplinecolor);
    end
end
