function this = simplot(fig, Experiments, varargin)
% Constructor
%  H = SIMPLOT(FIG,EXPERIMENTS) creates a plot that compares
%  the model output response with the test data in EXPERIMENTS.

%  Author(s): Bora Eryilmaz
%  Copyright 1986-2004 The MathWorks, Inc.
%  $Revision: 1.1.6.4 $ $Date: 2004/04/16 22:21:34 $

% Create class instance
this = speviews.simplot;

% Determine grid size
[OutputPorts,OutputPortSizes] = getPortHandles(Experiments);
ExpNames = get(Experiments,{'Description'});
gridsize = [length(OutputPorts) length(Experiments)];

% Generic property init
init_prop(this, [], gridsize);

% User-specified initial values (before listeners are installed...)
this.InputName = ExpNames;
this.OutputName = utGetPortName(OutputPorts);
this.OutputPort = OutputPorts;
this.OutputPortSize = OutputPortSizes;
this.TimeFocus = getfocus(this,Experiments);
this.set(varargin{:});

% Initialize the handle graphics objects
this.initialize(fig, gridsize)

% Add test data view
addTestData(this,Experiments)

% Make visible
this.Visible = 'on';

% Add menus
setmenus(this)
