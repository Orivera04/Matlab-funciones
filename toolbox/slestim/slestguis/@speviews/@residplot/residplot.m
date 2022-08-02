function this = residplot(fig, Experiments, varargin)
% Constructor
%  H = RESIDPLOT(FIG,EXPERIMENTS) creates a residual plot
%  relative to the test data in EXPERIMENTS.

%  Author(s): Bora Eryilmaz
%  Copyright 1986-2002 The MathWorks, Inc.
%  $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:21:01 $

% Create class instance
this = speviews.residplot;

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

% Make visible
this.Visible = 'on';

% Add menus
setmenus(this)

