function this = StateImport( Node, parent )
% STATEIMPORT Constructor for @StateImport class
%
% NODE needs to have a States property.
% States is a handle vector of objects with the Block property.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.7 $ $Date: 2004/04/11 00:38:07 $

this = spedialogs.StateImport;

% Store the current node
this.Node = Node;

% Listeners
prop = findprop(Node, 'States');
L = [ handle.listener(Node, prop, 'PropertyPostSet', { @LocalUpdate }); ...
      handle.listener(this, 'ObjectBeingDestroyed', { @LocalDispose }); ...
      handle.listener(Node, 'ObjectBeingDestroyed', { @LocalDelete }) ];
set(L, 'CallbackTarget', this);
this.Listeners = [this.Listeners; L ];

% Configure callbacks & listeners
LocalConfigureDialog( this, parent );
configureButtons( this );

% ----------------------------------------------------------------------------- %
% Configure the dialog
function LocalConfigureDialog(this, parent)
% Get the handles
Handles = this.Handles;

% Store the java panel handle
Dialog = com.mathworks.toolbox.slestim.variables.StateImportDialog(parent);
this.Dialog = Dialog;

% Table handle
Handles.ImportTable = this.Dialog.getImportTable;

% Store the handles
this.Handles = Handles;

% --------------------------------------------------------------------------
function LocalUpdate(this, hData)
% Update dialog
if this.Dialog.isVisible
  setViewData(this)
end

% --------------------------------------------------------------------------
function LocalDispose(this, hData)
% Delete dialog
dispose(this.Dialog)

% --------------------------------------------------------------------------
function LocalDelete(this, hData)
% Delete object
delete(this)
