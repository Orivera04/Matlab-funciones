function ret=cancopy(nd)
% CANCOPY  Indicate whether node can copy data
%
%  OUT=CANCOPY(NODE)
%  The return value is non-zero if one of the nodes
%  currently on display is in a state from which data
%  can be copied.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:25:23 $

cgb=cgbrowser;
d=cgb.getViewData(guid(nd));
tp = d.Handles.TablePane;

pane = tp(1);
ret=pane.canCopy;
if ~ret & length(tp)>1
    pane = tp(2);
    ret=pane.canCopy;
end

