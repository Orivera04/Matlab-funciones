function addestim(this, hEstim)
% Adds wave for a new estimation run.

% Author(s): Bora Eryilmaz
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:41:17 $

% Create data source
DataSrc  = speviews.estimsource( hEstim );

% Create a new @waveform object
wf = this.addwave(DataSrc);
wf.Name = hEstim.Description;
wf.DataFcn = {@getTrajectory DataSrc wf};

% Update plot visibility
setActivePlots(this)
