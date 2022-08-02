function addestim(this, hEstim)
% Adds wave for a new estimation run.

% Author(s): Bora Eryilmaz
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:40:52 $

% Create data source
DataSrc  = speviews.estimsource( hEstim );

% Create a new @waveform object
wf = wavepack.waveform;
wf.Name = hEstim.Description;
wf.Parent = this;
wf.RowIndex = 1;
wf.ColumnIndex = 1;

% Link to data source
wf.DataSrc = DataSrc;
wf.DataFcn = {@getCost DataSrc wf};

% Initialize new @waveform
initialize(wf,1)

% Add default tip (tip function calls MAKETIP first on data source, then on view)
addtip(wf)

% Set style
% RE: Before adding wave to plot's wave list so that legend available to RC menus
SList = get(allwaves(this),{'Style'});
StyleList = cat(1,SList{:});
wf.Style = this.StyleManager.dealstyle(StyleList);  % use next available style

% Resolve unspecified name against all existing "untitledxxx" names
setDefaultName(wf,this.Waves)

% Add to list of waves
this.Waves = [this.Waves ; wf];
