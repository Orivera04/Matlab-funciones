function View = view(nd,cgh,View)
%VIEW Refresh the browser display
%
%  View = VIEW(nd,cgh,View) refreshes the browser display for the node nd.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/02/09 08:38:50 $

if strcmp(View.guid, 'cgtradeoff')
    View.GUI.refresh;
else
    if ~View.SkipViewUpdate
        % Only refresh if the show method has not just been called
        View.GUI.changeTradeoff(address(nd), []);
    else
        View.SkipViewUpdate = false;
    end
end
