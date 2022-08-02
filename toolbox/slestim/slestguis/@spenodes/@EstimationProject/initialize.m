function initialize(this)
% INITIALIZE  Initialize the object after it has been connected to the
% tree hierarchy.  Can traverse the tree at this point.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:39:03 $

% Add listeners
L = [ handle.listener( this, this.findprop('Model'), ...
                       'PropertyPostSet', @LocalModelChanged ) ];
set(L, 'CallbackTarget', this);
this.addListeners(L);

% Initialize fields & nodes
LocalModelChanged(this, []);

% ---------------------------------------------------------------------------- %
function LocalModelChanged(this, hEvent)
this.firePropertyChange( 'MODEL_CHANGED' );
