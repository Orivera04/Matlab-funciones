function [lyt,tblyt,data]= creategui(nd,info)
%CREATEGUI Create a view layout for the node
%
%  [lyt,tblyt,data]= creategui(nd,info);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.4.3 $  $Date: 2004/02/09 08:37:22 $

if strcmp(info.ViewID, 'cgtradeoff')
    % Create setup UI
    hTradeoffMenu = info.browserH.createmenu(guid(nd,xregpointer), 1);
    set(hTradeoffMenu, 'Label', 'Trade&off');

    % Make a setup GUI
    data.GUI = cgtradeoffgui.setupUI('Browser', info.browserH, ...
        'TradeoffMenu', hTradeoffMenu, ...
        'Visible', 'off');
    data.guid = info.ViewID;
else
    % Create list-based output UI
    menus = info.browserH.createmenu(guid(nd,assign(xregpointer, 1)),2);
    set(menus,{'Label'},{'&View';'&Inputs'});

    % Flag that tells the view method whether to completely replace the
    % message service's current tradeoff
    data.SkipViewUpdate = true;
    data.GUI = cgtradeoffgui.listCentricUI('Browser', info.browserH, ...
        'ViewMenu', menus(1), ...
        'InputsMenu', menus(2), ...
        'Visible', 'off');

    data.guid = info.ViewID;
end
lyt = data.GUI.Layout;
tblyt = data.GUI.Toolbar;
