function T = detachData(T)
%DETACHDATA detach modeling data from test plan
% 
% unlinks data from testplan
% deletes responses

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.8.3 $  $Date: 2004/04/04 03:31:34 $

if ~IsMatched(T)
    error('mbc:mdevtestplan:InvalidState', 'No Data attached to the testplan') 
end
% Save current best models
T.Responses = children(T, 'model');
% Need to save because the subsequent call to delete children modifies
% the heap copy of the testplan
xregpointer(T);    
% Delete all responses
children(T, 'delete');
% Note that response deletion modifies the heap, so get an up-to-date
% copy
T = info(T);
% Indicate we have no data
T.DataLink = xregpointer;
T.Matched = 0;
% Also free up the internal global and local data pointers
[Xp, Yp] = dataptr(T);
freeptr(Xp);
freeptr(Yp);
% And point at nothing
T = AssignData(T, {xregpointer, xregpointer});
% Update the heap - Possibly not needed but keep it in for good measure
xregpointer(T);
% Need to ensure that the data is converted back to a sweepsetfilter or
% deleted if it is has a duplicate. This is done by the project as it
% actually owns the data pointers
cleanupData(info(project(T)));
