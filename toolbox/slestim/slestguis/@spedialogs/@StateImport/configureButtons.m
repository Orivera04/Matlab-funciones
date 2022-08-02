function configureButtons(this)
% CONFIGUREBUTTONS 

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/19 01:32:58 $

% Get the dialog handle
Dialog = this.Dialog;

% Configure buttons
L = [ handle.listener( handle(Dialog.getHelpButton), ...
                       'ActionPerformed', @LocalHelpButton ); ...
      handle.listener( handle(Dialog.getOkButton), ...
                       'ActionPerformed', @LocalOKButton ); ...
      handle.listener( handle(Dialog.getApplyButton), ...
                       'ActionPerformed', @LocalApplyButton ); ...
      handle.listener( handle(Dialog.getCancelButton), ...
                       'ActionPerformed', @LocalCancelButton ) ];

set(L, 'CallbackTarget', this);
this.Listeners = [this.Listeners; L];

% ----------------------------------------------------------------------------- %
function LocalHelpButton(this, hData)
% Launch the help browser
helpview([docroot '/toolbox/slestim/slestim.map'], 'state_select')

% ----------------------------------------------------------------------------- %
function LocalOKButton(this, hData)
% Call the apply callback
LocalApplyButton(this);

% Call the cancel callback
LocalCancelButton(this);

% ----------------------------------------------------------------------------- %
function LocalCancelButton(this, hData)
% Close the dialog
awtinvoke(this.Dialog, 'setVisible', false);

% ----------------------------------------------------------------------------- %
function LocalApplyButton(this, hData)
setModelData(this);
