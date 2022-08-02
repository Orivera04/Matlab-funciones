%UIMENU Create user interface menu.
% 	UIMENU('PropertyName1',value1,'PropertyName2',value2,...) creates
%   	a menu on the menu bar at the top of the current figure window,
%   	and returns a handle to it.
% 
% 	UIMENU(H,...) creates a new menu with H as a parent. H must be a
%	figure handle or a menu handle. If H is a figure handle, UIMENU
%   	creates a menu on the menu bar at the top of the window. If H is
%   	handle to a menu on the menu bar, the new menu is a menu item
%   	beneath the parent item on the menu bar.  If H is a handle to a
%   	menu item, UIMENU creates a walking menu beneath the menu item.
%
%	Menu properties can be set at object creation time using
%   	PropertyName/PropertyValue pair arguments to UIMENU, or changed
%   	later using the SET command.
%
%       Execute GET(H) to see a list of UIMENU object properties and
%       their current values. Execute SET(H) to see a list of UIMENU
%       object properties and legal property values. See a reference
%   	guide for more information.
%
%	See also SET, GET, UICONTROL.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
