function View = show(nd,cgh,View)
%SHOW Configure the browser layout
%
%  View = SHOW(nd,cgh,View) configures the browser display for the node nd.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/02/09 08:38:45 $

if strcmp(View.guid, 'cgtradeoff')
    View.GUI.Tradeoff = address(nd);
else
    View.GUI.changeTradeoff(address(nd), []);
    View.SkipViewUpdate = true;
end
