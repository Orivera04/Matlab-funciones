function d = pMessage(d, str)
%PMESSAGE Interface for editing browser message
%
%  DATA = PMESSAGE(DATA,  STR) sets STR to be the current message in the
%  feature node's browser view.  Any existing message is removed.  If STR
%  is empty, any existing message is removed and no new message is added.
%  DATA is the view data structure for feature nodes.
%
%  This function should only be used by methods that are guaranteed to have
%  been called from a browser callback.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.5 $    $Date: 2004/04/20 23:19:10 $ 

CGBH = cgbrowser;
if isfield(d, 'Handles') ...
        && isfield(d.Handles, 'MessageID') ...
        && ~isempty(d.Handles.MessageID);
    CGBH.removeStatusMsg(d.Handles.MessageID);
    d.Handles.MessageID = [];
end

if ~isempty(str)
    d.Handles.MessageID = CGBH.addStatusMsg(str);
end
CGBH.setViewData(d);
