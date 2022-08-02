function out=freepoints(des,inds)
%FREEPOINTS Return free design points
%
%  INDS=FREEPOINTS(D) returns the current free points.  These are points
%  that have not either been fixed by the user or marked as data points.
%
%  See also: FIXPOINTS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:06:36 $

out = find(~(pGetFlags(des, 'FIXED') | pGetFlags(des, 'DATA')));
