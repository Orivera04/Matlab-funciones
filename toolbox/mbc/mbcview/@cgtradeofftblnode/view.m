function d = view(node,cg,d)
%VIEW Tradeoff table browser GUI function.
%
%  DATA = VIEW(NODE, BROWSER, DATA) is called to refresh the display of the
%  browser.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:39:03 $

if ~d.SkipViewUpdate
    pTbl = getdata(node);
    d.GUI.changeTable(pTbl);
else
    d.SkipViewUpdate = false;
end
