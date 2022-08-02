function initialize(this, model)
% INITIALIZE Initialize object properties
%
% MODEL is a Simulink model name or handle.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:42:25 $

% Get Simulink object corresponding to model
util = slcontrol.Utilities;
h    = getModelHandle(util, model);

% Set properties
this.Model = h.getFullName;
this.Description = [ this.Model, ' experiment' ];
