function [pActive, pPassive] = getOutputs(obj)
%GETOUTPUTS Return the output pointers for the tradeoff
%
%  [PACTIVE, PPASSIVE] = GETOUTPUTS(OBJ) returns the lists of active
%  (should be shown) and passive (currently hidden) output pointers.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:35 $ 

pOut = pGetOutputs(obj);

% Split into Active and Passive using the current hidden list
pHidden = getHiddenExpressions(obj);
ishidden = ismember(pOut, pHidden);
pActive = pOut(~ishidden);

if nargout>1
    pPassive = pOut(ishidden);
end
