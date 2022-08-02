function menu = getPopupSchema(this, manager)
% GETPOPUPSCHEMA Constructs node's popup menu

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:39:08 $

menu  = com.mathworks.mwswing.MJPopupMenu('Default Menu');
item1 = com.mathworks.mwswing.MJMenuItem('Add');

menu.add( item1 );

h = handle( item1, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalAdd, this, manager };
h.MouseClickedCallback    = { @LocalAdd, this, manager };

% --------------------------------------------------------------------------- %
function LocalAdd(hSrc, hData, this, manager)
this.addNode;
