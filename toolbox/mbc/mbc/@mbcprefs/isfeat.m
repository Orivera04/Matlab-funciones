function ret=isfeat(p,feat)
%ISFEAT   indicate whether a feature name is valid
%
%  RET=ISFEAT(FEAT) returns 1 if FEAT is a valid feature name
%  and 0 otherwise.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:45:00 $

% Created 16/6/2000

ret=pr_datastore('isfeat',feat);
return