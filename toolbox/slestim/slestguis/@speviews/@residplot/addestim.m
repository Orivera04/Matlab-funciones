function addestim(this, hEstim)
% Adds wave for a new estimation run.

% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:20:59 $

% Create data source
DataSrc = speviews.simsource( hEstim);

% Create a new @waveform object
wf = this.addresponse(DataSrc);
wf.Name = hEstim.Description;
wf.DataFcn = {@getError DataSrc wf};

% Sizing
nrow = length(wf.RowIndex);
ncol = length(wf.ColumnIndex);
wf.Data.SimData = struct('Time',cell(nrow,ncol),'Amplitude',[]);
wf.View.PortSize = this.OutputPortSize(wf.RowIndex);
