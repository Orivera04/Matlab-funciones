function View=view(nd,cgh,View)
%VIEW Update the browser display
%
%  View = view(nd,cgh,View) updates the browser display and returns an
%  updated View information structure.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.2.4 $  $Date: 2004/04/04 03:33:31 $

cgmod = cgh.CurrentNode.getdata;
if ~View.SkipViewUpdate
    View.ExprView.update;
    View.ModelView.update;
else
    View.SkipViewUpdate = false;
end
