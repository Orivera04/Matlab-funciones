function initialize(this)
% INITIALIZE  Initialize the object after it has been connected to the
% tree hierarchy.  Can traverse the tree at this point.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:40:39 $

parent = find(this.getRoot, '-class', 'spenodes.EstimationProject');

% Add property listeners
L = [ handle.listener(parent, 'PropertyChange', @LocalPropertyChange) ];
set(L, 'CallbackTarget', this);
this.addListeners(L);

LocalPropertyChange(this, explorer.dataevent(this, 'MODEL_CHANGED', '', ''));

% ---------------------------------------------------------------------------- %
function LocalPropertyChange(this, hEvent)
if strcmp(hEvent.propertyName, 'MODEL_CHANGED')
  % Send notification to ViewerLeaf UDD objects.
  this.firePropertyChange('DATA_CHANGED');
end
