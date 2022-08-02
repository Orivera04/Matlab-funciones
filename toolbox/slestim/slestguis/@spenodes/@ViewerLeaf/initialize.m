function initialize(this)
% INITIALIZE Initialize the object after it has been connected to the
% tree hierarchy.  Can traverse the tree at this point.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:40:47 $

parent = find(this.getRoot, '-class', 'spenodes.Viewer');

% Add property listeners
L = [ handle.listener(parent, 'PropertyChange', @LocalViewChanged) ];
set(L, 'CallbackTarget', this);
this.addListeners(L);

% Initialize view data
LocalUpdate(this);

% ---------------------------------------------------------------------------- %
function LocalViewChanged(this, hEvent)
if strcmp(hEvent.propertyName, 'DATA_CHANGED')
  LocalUpdate(this)
end

% --------------------------------------------------------------------------
function LocalUpdate(this)
% Initialize tables
plotsdata = { 'Plot 1', '(none)', ''; ...
              'Plot 2', '(none)', ''; ...
              'Plot 3', '(none)', ''; ...
              'Plot 4', '(none)', ''; ...
              'Plot 5', '(none)', ''; ...
              'Plot 6', '(none)', '' };

if isempty(this.Fields.Plots)
  this.Fields.Plots = plotsdata;
end
