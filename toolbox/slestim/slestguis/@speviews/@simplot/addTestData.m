function addTestData(this,Experiments)
% Creates @siminput object for storing input data

%  Author(s): P. Gahinet
%  Copyright 1986-2002 The MathWorks, Inc.
%  $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:21:28 $
Test = wavepack.waveform;
Test.Parent = this;
Test.Name = 'Driving inputs';

% Localize in plot
nexp  = length(Experiments);
nport = length(this.OutputPort);
Test.RowIndex    = 1:nport;
Test.ColumnIndex = 1:nexp;

% Create data object and populate it
Data = speviews.respdata;
Data.SimData = struct('Time', cell(nport,nexp), 'Amplitude', []);
for cte = 1:length(Experiments)
  e = Experiments(cte);
  [junk,ia,ib] = intersect(this.OutputPort, getPortHandles(e,'NoSort'));
  
  for ctp=1:length(ia)
    hOut = e.OutputData(ib(ctp));
    OutData = hOut.Data;
    nd = length(hOut.Dimensions);
    if nd > 1
      % Convert to 2-D array
      OutData = permute(OutData, [nd+1,1:nd]);
      OutData = reshape( OutData, [], prod(hOut.Dimensions) );
    end
    Data.SimData(ia(ctp),cte).Time      = e.OutputData(ib(ctp)).Time;
    Data.SimData(ia(ctp),cte).Amplitude = OutData;
  end
end
Test.Data = Data;

% Create view object
View = speviews.testview;
View.AxesGrid = this.AxesGrid;
initialize(View,getaxes(this))
View.PortSize = this.OutputPortSize(Test.RowIndex);
Test.View = View;

% Add listeners
addlisteners(Test)

% Line styles
LineStyles = {'-';'--';':';'-.'};
Style = wavepack.wavestyle;
Style.Colors = {[.6 .6 .6]};  % gray
Style.LineStyles = reshape(LineStyles,[1 1 4]);
Style.Markers = {'none'};
Test.Style = Style;

% Install tips
addtip(Test)

this.TestData = Test;
