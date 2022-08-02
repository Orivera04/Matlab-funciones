function [P, L, parent] = layerinfo(s,layer,thisptr)
%LAYERINFO Information for drawing model linkages
%
%  [P, L, PRNT] = LAYERINFO(E, LAYER, THISPTR)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:27:25 $

P = [];
L = [];
parent = [];
Inputs = getinputs(s);
Inputs = Inputs(isvalid(Inputs));
InputObjects = infoarray(Inputs);
for n = 1:length(InputObjects)
    [nextp,nextl,nextparent] = layerinfo(InputObjects{n},layer+1,Inputs(n));
    P = [P Inputs(n) nextp];
    L = [L layer nextl];
    parent = [parent thisptr nextparent];
end
