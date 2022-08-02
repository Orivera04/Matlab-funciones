function varargout = sweepplot(X, varargin)
%SWEEPPLOT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/02/09 08:11:42 $

% Test to see if we have a multi sweep plot
sizeX = size(X);
numSweeps   = sizeX(3);
MULTI_SWEEP = numSweeps > 1;
MULTI_VARS  = sizeX(2) > 1;
flags = struct('LEGEND',1);

% If we don't have multiple sweeps then pass down to sweepset/plot - Note
% that we do not treat 1 test per record as a multi-sweep plot
if MULTI_VARS || isequal(sizeX(1), numSweeps)
    [h, l, axesH] = plot(X, varargin{:});
    set(l, 'MoveMode', 'boundtoaxes', ...
        'LockVisibleToParent', true);
else
	% Make sure we have an axis handle for multiple plotting and know if the second argument
	% is a sweepset
	axesH = [];
	Y = [];
	l = [];
	for i = 1:length(varargin)
		switch class(varargin{i})
		case 'sweepset'
			Y = varargin{i};
		case 'char'
			switch lower(varargin{i})
            case 'plotproperties'
                if isstruct(varargin{i+1})
                    flags.LEGEND = strcmp(lower(varargin{i+1}.showLegend), 'on');
                end
			case 'parent'
				axesH = varargin{i+1};
			case 'legend'
				flags.LEGEND = strcmp(lower(varargin{i+1}), 'on');
			end
		end
	end
	if isempty(axesH)
		axesH = gca;
	end
	
	% Now ensure we only have one Y variable (Note we know we have Multiple sweeps)
 	S.type = '()';
	numVars = size(Y,2);
	nextPlotState = get(axesH, 'NextPlot');
	visibleState  = get(axesH, 'visible');
	colorOrder = get(axesH, 'ColorOrder');
    markerOrder = 'ox+*sdv^<>ph';
    colorOrderIndex = 0;
	h = zeros(numVars, numSweeps);
    for i = 1:numSweeps
        % Call sweepset/subsref to get the relevant sweep of a sweepset
        S.subs = {':' 1 i};
        currX = subsref(X, S);
        if isempty(Y)
            h(i) = plot(currX, varargin{:});
        else
            S.subs = {':' ':' i};
            currY = subsref(Y, S);
            % Note legend off has precedence over any inputs in varargin
            h(:,i) = plot(currX, currY, varargin{2:end}, 'legend', 'off');
        end
        % Set the color of the line in accordance with the axes colorOrder property
        for j = 1:size(h, 1)
            colorIndex = mod(colorOrderIndex, size(colorOrder,1)) + 1;
            set(h(j, i), 'color', colorOrder(colorIndex, :));
            colorOrderIndex = colorOrderIndex + 1;
        end
        if numSweeps > 1
            markerIndex = mod(i-1, length(markerOrder)) + 1;
            set(h(:,i), 'marker', markerOrder(markerIndex));
        end
        % Make sure the next plot is added rather than clearing the axes
        set(axesH, 'NextPlot', 'add');
    end
	% Need to ensure that axesH is visible to attach a legend
	set(axesH, 'visible', 'on');
	% Have we got multiple sweeps and vars here?
	if (MULTI_SWEEP || MULTI_VARS || ~isempty(Y)) && flags.LEGEND
		if size(h,1) > 1
            tn = testnum(X);
            labels = repmat(detex(get(Y, 'name')), numSweeps, 1);
            for m = 1:numSweeps
                labels{(m-1)*numVars+1} = sprintf('%s     \\langle{\\bf%d}\\rangle', labels{(m-1)*numVars+1}, tn(m));
            end
        else
            tn = testnum(X);
            labels = cell(length(tn),1);
            for n = 1:length(labels)
                labels{n} = sprintf('%d', tn(n));
            end
        end
        h = h(:);
        l = mbcgraph.legend(h, labels, ...
            'Interpreter', 'tex', ...
            'MoveMode', 'boundtoaxes', ...
            'LockVisibleToParent', true);
	end
	set(axesH, 'NextPlot', nextPlotState, 'visible', visibleState);
end

% Attach a listener to the visible property of the axes to hide the legend
a = handle(axesH);
if isempty(a.findprop('legendListener'))
	schema.prop(a, 'legendListener', 'handle vector');
end
if isempty(a.findprop('legendHandle'))
	schema.prop(a, 'legendHandle', 'handle');
end
% Might not have drawn any lines so need to account for that in the length
% of h
if length(h)>0
    a.legendListener = handle.listener(h(1), 'ObjectBeingDestroyed', {@i_deleteLegend,  l});
end
a.legendHandle = l;

if nargout > 0
	varargout{1} = h;
	varargout{2} = l;
end

%------------------------------------------------------------------------
function i_deleteLegend(src, event, leg)
if ishandle(leg)
	delete(leg); 
end
