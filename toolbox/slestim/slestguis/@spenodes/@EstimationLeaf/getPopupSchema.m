function menu = getPopupSchema(this, manager)
% GETPOPUPSCHEMA Constructs node's popup menu

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:38:49 $

menu  = com.mathworks.mwswing.MJPopupMenu('Default Menu');
item1 = com.mathworks.mwswing.MJMenuItem('Delete');
item2 = com.mathworks.mwswing.MJMenuItem('Rename');

menu.add( item1 );
menu.add( item2 );

h = handle( item1, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalDelete, this, manager };
h.MouseClickedCallback    = { @LocalDelete, this, manager };

h = handle( item2, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalRename, this, manager };
h.MouseClickedCallback    = { @LocalRename, this, manager };

% --------------------------------------------------------------------------- %
function LocalDelete(hSrc, hData, this, manager)
parent = this.up;
parent.removeNode(this);
manager.Explorer.setSelected(parent.getTreeNodeInterface);

% --------------------------------------------------------------------------- %
function LocalRename(hSrc, hData, this, manager)
Tree = manager.ExplorerPanel.getSelector.getTree;
Tree.startEditingAtPath(Tree.getSelectionPath);
