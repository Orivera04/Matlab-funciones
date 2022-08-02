function d = pMessage(d, str)
%PMESSAGE Interface for editing browser message
%
%  DATA = PMESSAGE(DATA,  STR) sets STR to be the current message in the
%  normaliser node's browser view.  Any existing message is removed.  If STR
%  is empty, any existing message is removed and no new message is added.
%  DATA is the view data structure for normaliser nodes.
%
%  This function should only be used by methods that are guaranteed to have
%  been called from a browser callback.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/04/10 23:34:57 $ 

CGBH = cgbrowser;
if isfield(d, 'Handles.MessageID') && ~isempty(d.Handles.MessageID);
    CGBH.removeStatusMsg(d.Handles.MessageID);
    d.Handles.MessageID = [];
end

if ~isempty(str)
    d.Handles.MessageID = CGBH.addStatusMsg(str);
end
CGBH.setViewData(d);
