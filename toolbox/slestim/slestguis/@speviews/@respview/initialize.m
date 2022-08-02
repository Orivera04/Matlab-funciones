function initialize(this, Axes)
% Initializes @respview graphics.

% Author(s): Bora Eryilmaz
% Copyright 1986-2002 The MathWorks, Inc.
% $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:21:22 $
[nport,nexp] = size(Axes);

% Create one curve in each bin
SimPlots = cell(nport,nexp);
for ct=1:nport*nexp
  SimPlots{ct} = line(NaN,NaN,'Parent',Axes(ct),'Visible', 'off');
end
this.SimPlot = SimPlots;

% Port sizes
this.PortSize = cell(nport,1);
