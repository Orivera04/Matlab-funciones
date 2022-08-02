function setmenus(this)
%  Author(s): Bora Eryilmaz
%  Revised:
%  Copyright 1986-2004 The MathWorks, Inc.
%  $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:41:25 $

AxesGrid = this.AxesGrid;

% Group 1
m = this.addMenu('waves');
set(m, 'Label', 'Estimations');

m = this.addMenu('channelgrouping');
set(m, 'Label', 'Plot Grouping');

m = this.addMenu('channelselector');
set(m, 'Label', 'Parameter Selector');

% Group 2
AxesGrid.addMenu('grid', 'Separator', 'on');
this.addMenu('fullview'); 

% Group 3
this.addMenu('properties', 'Separator', 'on');
