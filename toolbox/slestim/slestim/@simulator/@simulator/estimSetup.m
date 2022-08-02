function estimSetup(this)
% Performs initialization tasks when estimation starts.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2004/03/24 21:12:45 $

% Reset data logs
this.DataLog.X = [];
this.GradLog   = [];
   
% Notify dependencies
E = handle.EventData(this, 'EstimStart');
this.send('EstimStart', E)
