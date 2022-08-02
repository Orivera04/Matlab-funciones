function this = ParameterImport( Node, parent )
% PARAMETERIMPORT Constructor for @ParameterImport class
%
% NODE needs to have a Parameters property.
% Parameters is a handle vector of objects with the Name property.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.7 $ $Date: 2004/04/11 00:38:01 $

this = spedialogs.ParameterImport;

% Store the current node
this.Node = Node;

% Listeners
prop = findprop(Node, 'Parameters');
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
Dialog = com.mathworks.toolbox.slestim.variables.ParameterImportDialog(parent);
this.Dialog = Dialog;

% Table handle
Handles.ImportTable = this.Dialog.getImportTable;
Handles.ImportField = this.Dialog.getImportField;

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
