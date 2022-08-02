function d = show(nd , cgh , d)
%SHOW Tradeoff table browser GUI function.
%
%  DATA = SHOW(NODE, BROWSER, DATA) is called to initialise the tradeoff
%  table's browser GUI.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.11.2.4 $  $Date: 2004/02/09 08:39:02 $

lastnode = cgh.PreviousNode;
pTO = Parent(nd);
if isnull(lastnode) || ~isSibling(nd, lastnode)
    % Need to set a completely new tradeoff object and then tell view
    % operation not to do anything
    pTbl = getdata(nd);
    d.GUI.changeTradeoff(pTO, pTbl);
    
    d.SkipViewUpdate = true;
end
