function viewdata = pSetComparisonMenu( viewdata )
%PSETCOMPARISONMENU Enables the Comparison menu based on the state of the
%split
%
%  OUT = PSETCOMPARISONMENU(IN)

%  Copyright 2000-2003 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/04/04 03:33:35 $ 

splitlayout = viewdata.Handles.Display;
menu = viewdata.Handles.Menus.comparison;

if strcmp(get(splitlayout,'state'),'bottom')
    set(menu,'checked','off');
else
    set(menu,'checked','on');
end
set(menu,'enable',get(splitlayout,'splitenable'));
