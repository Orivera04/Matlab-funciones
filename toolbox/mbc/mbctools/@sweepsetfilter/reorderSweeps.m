function ssf = reorderSweeps(ssf, newOrder)
%REORDERSWEEPS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:12:09 $

% Sweepset level 1 compliant only
ssf.reorderSweeps = {newOrder};
% Update the sweepsetfilter
ssf = updateReorderSweeps(ssf);
% And queue an event indicating the sweepset have been changed
queueEvent(ssf, 'ssfSweepOrderChanged');