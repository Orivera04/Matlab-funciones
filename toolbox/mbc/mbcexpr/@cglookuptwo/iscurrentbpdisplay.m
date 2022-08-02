function out = iscurrentbpdisplay(T,ud)
%ISCURRENTBPDISPLAY

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:48 $

% CGLOOKUPTWO/ISCURRENTBPDISPLAY :: tells us whether this table is currently being properly displayed 
% in the BP editor - used when a refresh is called and we don't know what has triggered it so we might
% needd to do a full reboot, or altenatively leave well alone.

out = 0;

if ~isequal(ud.DisplayFlags.PaneVisibility(1:2),[1;1])
    % if the pane visibility isn't right then the display can't be.
    return
end

xNormaliser = get(T,'x');
BPx = xNormaliser.get('breakpoints');

tempBPx = ud.TablePane(1).Handles.Table(2:end,1);

yNormaliser = get(T,'y');
BPy = yNormaliser.get('breakpoints');

tempBPy = ud.TablePane(2).Handles.Table(2:end,1);

if ~isequal(tempBPx,BPx) | ~isequal(tempBPy,BPy)
    out = 0;
else
    out = 1;
end
return