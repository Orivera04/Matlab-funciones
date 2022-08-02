function varargout = ListFcns(obj, hList, action);
%LISTFCNS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:26:48 $

% This function handles book-keeping for click events from the three list controls

switch(action)
case 'click'
   i_CheckRun;
end

%------------------------------------------------------------------------------
function i_CheckRun
%------------------------------------------------------------------------------
%I_CHECKRUN Enable/disable the run menu item as appropriate

CGBH = cgbrowser;
d = CGBH.getViewData;
pN = CGBH.CurrentNode;
pOpt = pN.getdata;
[OK, reason] = checkrun(pOpt.info, 'gui');
if OK
    set(d.Handles.RunMenu, 'enable', 'on');
    set(d.Handles.Toolbar.Run, 'enable', 'on');
    set(d.Handles.SetUpandRunMenu, 'enable', 'on');
    set(d.Handles.Toolbar.SetUpandRun, 'enable', 'on');
else
    set(d.Handles.RunMenu, 'enable', 'off');
    set(d.Handles.Toolbar.Run, 'enable', 'off');    
    set(d.Handles.SetUpandRunMenu, 'enable', 'off');
    set(d.Handles.Toolbar.SetUpandRun, 'enable', 'off');
end

