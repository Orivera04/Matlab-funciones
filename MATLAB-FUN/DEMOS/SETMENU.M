function setmenu(menuHndl,labelList,callbackList);
%SETMENU Function for quickly setting up hierarchical menus.
%	Used by EXPOMENU.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

for count=1:size(labelList,1),
    uimenu(menuHndl, ...
    	'Label',deblank(labelList(count,:)), ...
    	'Callback',callbackList(count,:));
end;

