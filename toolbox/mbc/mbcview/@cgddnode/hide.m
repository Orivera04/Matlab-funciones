function [View,OK]=hide(nd,cgh,View)
%HIDE
%  View=hide(nd,cgh,View)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 08:23:26 $

OK = 1;
d = cgh.getViewData;

if isfield(d, 'StatusMsgID')
    if ~isempty(d.StatusMsgID)
        cgh.removeStatusMsg(d.StatusMsgID);
        d.StatusMsgID = [];
    end
end

cgh.setViewData(d);

