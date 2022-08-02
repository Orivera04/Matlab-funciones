function [mainlyt,tlb,d] = creategui(nd,info)
%CREATEGUI Creates the browser GUI interface for tradeoff tables.
%
%  [LAYOUT, TOOLBAR, DATA] = CREATEGUI(NODE, INFO) where INfO is a
%  structure containing the fields Figure and browserH.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.2.3 $  $Date: 2004/02/09 08:38:56 $

cgb = info.browserH;

% Make the menus
menus = cgb.createmenu(guid(nd),3);
set(menus,{'Label'},{'&View';'Ta&bles';'&Inputs'});

% Flag that tells the view method whether to completely replace the
% message service's current tradeoff
d.SkipViewUpdate = true;

% Main GUI is entirely encapsulated
d.GUI = cgtradeoffgui.tableCentricUI('Browser', cgb, ...
    'ViewMenu', menus(1), ...
    'TablesMenu', menus(2), ...
    'InputsMenu', menus(3), ...
    'Visible', 'off');

mainlyt = d.GUI.Layout;
tlb = d.GUI.Toolbar;
