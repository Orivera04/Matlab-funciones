function setmenus(this)
%  Author(s): Bora Eryilmaz
%  Copyright 1986-2002 The MathWorks, Inc.
%  $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:21:17 $
AxesGrid = this.AxesGrid;

% Group 1
m = this.addMenu('responses');
set(m, 'Label', 'Estimations');

m = this.addMenu('iogrouping');
set(m, 'Label', 'Plot Grouping');
% Tweak labels
c = get(m,'Children');
Labels = get(c,{'Label'});
Labels = strrep(Labels,'Inputs','Experiments');
set(c,{'Label'},Labels)

m = this.addMenu('ioselector');
set(m, 'Label', 'Row/Column Selector');

% Group 2
AxesGrid.addMenu('grid', 'Separator', 'on');
this.addMenu('fullview'); 

% Group 3
this.addMenu('properties', 'Separator', 'on');
