function initialize(this, model, varargin)
% INITIALIZE Initialize object properties
%
% MODEL is a Simulink model name or handle.
% VARARGIN 

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:42:17 $

% Get Simulink object corresponding to model
util = slcontrol.Utilities;
h    = getModelHandle(util, model);

% Set properties
this.Model       =  h.getFullName;
this.Description = [ this.Model, ' estimation' ];

% Options
this.OptimOptions = speoptions.OptimOptions;
this.SimOptions   = speoptions.SimOptions;
this.SimOptions.initialize(this.Model);
