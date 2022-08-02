function freeptr(T);
% TESTPLAN/FREEPTR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:07:46 $

[x,y]= dataptr(T);
if x~=0
   freeptr(x);
end
if y~=0
   freeptr(y);
end

% delete boundary modeling tree
if T.ConstraintData ~= 0,
    delete( T.ConstraintData.info );
end

% May need to delete the data associated with this testplan
if isvalid(T.DataLink)
    MP = info(project(T));
    MP= cleanupData(MP,address(T));
end