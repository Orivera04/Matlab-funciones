function show(this)
% SHOW Show the dialog

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/19 01:32:57 $

% Get tunable variables
util  = slcontrol.Utilities;
model = this.Node.getRoot.Model;
try
  this.TunableVars = getTunableParameters(util, model);
catch
  errmsg = util.getLastError;
  errordlg(errmsg, 'Parameter Selection Error', 'modal')
  return
end

% Show dialog
this.setViewData
awtinvoke(this.Dialog, 'setVisible', true);
