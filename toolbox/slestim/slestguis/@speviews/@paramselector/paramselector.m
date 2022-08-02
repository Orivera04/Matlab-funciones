function this = paramselector(ParamPlot,varargin)
% Constructor.

%   Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:41:26 $
this = speviews.paramselector;
this.Parent = ParamPlot;
this.Name = 'Parameter Selector';
Size = [max(1,length(ParamPlot.AllParameters)) 1];
this.Size = Size;
this.RowName = repmat({''},[Size(1) 1]);
this.RowSelection = logical(ones(Size(1),1));
this.ColumnName = repmat({''},[Size(2) 1]);
this.ColumnSelection = logical(ones(Size(2),1));

% User-specified properties (can be any prop EXCEPT Visible)
this.set(varargin{:});

% Construct GUI
build(this)

% Customize shape
f = this.Handles.Figure;
pos = get(f,'Position');
pos(3) = 1.5 * pos(3);
set(f,'Position',pos);

% Customize [all]
set(this.Handles.AllText,...
   'String',sprintf('[All Estimated]'),...
   'ButtonDownFcn',@(x,y) LocalSelectEstimated(this,ParamPlot))

% Add listeners
addlisteners(this)

%----------------- Local Functions ------------------------

function LocalSelectEstimated(this,ParamPlot)
this.RowSelection = isEstimatedParam(ParamPlot);
