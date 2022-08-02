%POPUPCB Script for handling Expo popup button callbacks.
%	This script is required to make sure that any data loaded
%	goes to the main workspace.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

popupHndl=gco;
demoVal=get(popupHndl,'Value');
% if demoVal=1, then take no action, because no demo has
% been chosen (demoVal=1 -> 'Select a demo' option).
if demoVal>1,
    figNumber=watchon;
    drawnow;
    demoList=get(popupHndl,'UserData');
    demoName=demoList(demoVal,:);
    eval(demoName);
    set(popupHndl,'Value',1);
    watchoff(figNumber);
end

