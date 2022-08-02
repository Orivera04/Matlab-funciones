function this = simulator(Experiment, States, SimOptions)
% SIMULATOR 

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:43:53 $

% Create object
this = simulator.simulator;

this.Experiment = Experiment;
this.SimOptions = SimOptions;
this.States     = States;
