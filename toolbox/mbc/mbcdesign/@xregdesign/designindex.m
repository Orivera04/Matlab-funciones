function inds=designindex(d)
% DESIGNINDEX  Return the candidate index for each design point
%
% I=DESIGNINDEX(D) returns the current candidate set index number for
% each design point.
%
% This number is not settable; it is maintained by functions which add
% a point to the design, such as augment and reinit.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:25 $

% Created 30/5/2000


inds=d.designindex;
