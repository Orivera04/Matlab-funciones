function d = view(node, cgb, d)
%VIEW  Update the browser display
%
%  UD = VIEW(NODE, CGB, UD) updates the data displayed in the browsers
%  table view.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:34:24 $

if ~d.SuppressViewUpdate
    pT = getdata(node);
    if pT.getNumAxes==1
        d.Handles.Editor1D.settable(pT);
    else
        d.Handles.Editor2D.settable(pT);
    end
    d.Handles.FeatureComp.plotcomparison(d.FeaturePointer, pT);
else
    % Skip updates for this view call as it follows a "show"
    d.SuppressViewUpdate = false;
end
