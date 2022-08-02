function pInitIndexControls(d, pOptim)
%PINITINDEXCONTROLS Initialise the index control strip
%
%  PINITINDEXCONTROLS(VIEWDATA, P_OPTIM) is a private method used in the
%  cgbrowser view GUI.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.2 $    $Date: 2004/04/04 03:33:52 $ 

% Set maximum limit on index selector and update label string, plus set the
% correct image source for the progress monitor
maxval = 0;
selval = 0;
sz = pOptim.getsolutionsize;
switch d.CurrentView
    case 1
        maxval = sz(3);
        selval = d.CurrentSolution;
        d.Handles.ViewIndex.String = 'Solution:';
        d.Handles.ViewIndex.Enable = 'on';
        d.Handles.progresswidget.imageSource = d.SolImages;
    case 2
        maxval = sz(1);
        selval = d.CurrentOpPoint;
        d.Handles.ViewIndex.String = 'Operating Point:';
        d.Handles.ViewIndex.Enable = 'on';
        d.Handles.progresswidget.imageSource = d.OpPtImages;
    case 3
        maxval = 1;
        selval = d.CurrentOpPoint;
        d.Handles.ViewIndex.String = 'Operating Point:';
        d.Handles.ViewIndex.Enable = 'off';
        d.Handles.progresswidget.imageSource = d.OpPtImages;
    case 4
        maxval = sz(3);
        selval = d.CurrentSolution;
        d.Handles.ViewIndex.String = 'Solution:';
        d.Handles.ViewIndex.Enable = 'off';
        d.Handles.progresswidget.imageSource = d.SolImages;
end
if length(selval)~=1
    % Guard against a non-scalar value
    selval = 1;
end
set(d.Handles.ViewIndex.Control, 'max', maxval, 'value', selval);
