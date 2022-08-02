function show(this)
% SHOW Show the dialog

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/19 01:32:59 $

% Get tunable states
util  = slcontrol.Utilities;
model = this.Node.getRoot.Model;
try
  this.TunableStates = getTunableStates(util, model);
catch
  errmsg = util.getLastError;
  errordlg(errmsg, 'State Selection Error', 'modal')
  return
end

% Show dialog
this.setViewData
awtinvoke(this.Dialog, 'setVisible', true);
