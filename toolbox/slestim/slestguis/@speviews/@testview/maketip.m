function str = maketip(this,tipobj,info)
% Build data tips for @testview curves.

%   Author(s): John Glass
%   Copyright 1986-2002 The MathWorks, Inc. 
%   $Revision: 1.1.4.1 $  $Date: 2004/04/16 22:21:44 $
r = info.Carrier;
AxGrid = info.View.AxesGrid;

pos = get(tipobj,'Position');
Y = pos(2);
X = pos(1);

% Normalization
if strcmp(AxGrid.YNormalization,'on')
   ax = tipobj.Parent;
   Y = denormalize(info.Data,Y,get(ax,'XLim'),info.Row,info.Col);
end
   
% Create tip text
str = strvcat(...
   this.rcinfo(r,info.Row,info.Col,tipobj.Host),...
   sprintf('Time (%s): %0.3g', AxGrid.XUnits, X),...
   sprintf('Amplitude: %0.3g', Y));
