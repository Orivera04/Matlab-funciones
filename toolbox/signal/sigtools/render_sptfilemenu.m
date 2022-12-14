function hfile = render_sptfilemenu(hFig)
%RENDER_SPTFILEMENU Render a Signal Processing Toolbox "File" menu.
%   HFILE = RENDER_SPTFILEMENU(HFIG) creates a "File" menu in the first position
%   on a figure whose handle is HFIG and return the handles to all the menu items.

%   Author(s): V.Pellissier
%   Copyright 1988-2002 The MathWorks, Inc.
%   $Revision: 1.6 $  $Date: 2002/07/17 13:16:30 $ 

strs = {xlate('&File'), ...
        xlate('&Export...'), ...
        xlate('Pre&ferences...'), ...
        xlate('Pa&ge Setup...'), ...
        xlate('Print Set&up...'), ...
        xlate('Print Pre&view...'), ...
        xlate('&Print...'), ...
        xlate('&Close')};

cbs = {'', ...
    'filemenufcn(gcbf,''FileExport'');', ...
    'preferences;', ...
    'pagesetupdlg(gcbf);', ...
    'printdlg(''-setup'', gcbf);', ...
    'printpreview(gcbf);', ...
    'printdlg(gcbf);', ...
    'close(gcbf)'};

tags = {'file', ...
    'export', ...
    'preferences', ...
    'pagesetup', ...
    'printsetup', ...
    'printpreview', ...
    'print', ...
    'close'};

sep = {'off', ...
    'off', ...
    'on', ...
    'on', ...
    'off', ...
    'off', ...
    'off', ...
    'on'};

accel = {'', ...
    '', ...
    '', ...
    '', ...
    '', ...
    '', ...
    'P', ...
    'W'};

hfile = addmenu(hFig,1,strs,cbs,tags,sep,accel);

% [EOF]
