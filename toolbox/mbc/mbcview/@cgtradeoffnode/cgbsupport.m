function supp=cgbsupport(nd, pSub, supp)
%CGBSUPPORT Get cgbrowser supported options
%
%  SUPP=CGBSUPPORT(OBJ, pSUB, SUPP) where SUPP is a structure of options
%  and pSUB is a pointer to the subitem to be shown, gets the options for
%  this particular node/subitem combination.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/02/09 08:37:17 $

if isnull(pSub)
    supp.calmanager = true;
    supp.renderer = 'painters';
    supp.allowremoval = true;
    supp.allowduplication = true;
    supp.helptopics = {'&Tradeoff Help','CGTRADEOFFVIEW'};
    supp.surfaceviewer = true;
    supp.surfaceviewernodesfcn = @i_gensurfviewernodes;
else
    supp.renderer = 'painters';
    supp.calmanager = false;
    supp.helptopics = {'&Tradeoff Table Help','CGTRADEOFFTBLVIEW'};
    supp.allowduplication = false;
    supp.allowremoval = false;
    supp.surfaceviewer = true;
    supp.surfaceviewernodesfcn = @i_gensurfviewernodes;
    supp.allowlabeledit = false;
end



function [pNodes, selidx] = i_gensurfviewernodes(node)
% Find list of model nodes that matches the current models of the tradeoff
[pActive, pPassive] = getOutputs(node);
pInTradeoff = [pActive, pPassive];
PROJ = project(node);
modelNodes = filterbytype(PROJ, cgtypes.cgmodeltype);
pNodes = null(xregpointer, size(pInTradeoff));
nDisp = 0;
for n = 1:length(modelNodes)
    pNode = findptr(modelNodes{n}, pInTradeoff);
    if ~isempty(pNode)
        nDisp = nDisp + 1;
        pNodes(nDisp) = pNode;
    end
end
pNodes = pNodes(1:nDisp);
selidx = 1;
