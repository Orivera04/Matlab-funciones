function h = makeGradient(this)
% Creates a gradient model for accurate gradient estimation.

% Author(s): P.Gahinet, Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/03/10 21:54:21 $

h = slcontrol.GradientModel( this.Model, this.Parameters );
set_param(h.GradModel, 'SignalLoggingName', 'SPE_GradLog')
