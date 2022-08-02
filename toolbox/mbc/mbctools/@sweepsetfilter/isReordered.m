function OK = isReordered(obj)
%SWEEPSETFILTER/SREORDERED does the ssf reorder the underlying data
%
% OK = ISREORDERED(OBJ)
%
%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:08:59 $ 

% The sweepsetfilter reorders if there is something in define tests and the
% reorder flag is logical true or the SILLY string that is used to indicate
% that old reordering with the bug should be used!
OK = ~isempty(obj.defineTests) & ...
    (obj.defineTests.reorder | strcmp(obj.defineTests.reorder, 'OldReorder-ThisFieldShouldBeLogical'));
    