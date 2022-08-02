function out=fixpoints(des)
%FIXPOINTS Return fixed design points
%
%  INDS=FIXPOINTS(D) returns the indices of the currently fixed points.
%  These are points that have either been fixed by the user or marked as
%  data points.
%
%  See also: FREEPOINTS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:06:35 $

out = find(pGetFlags(des, 'FIXED') | pGetFlags(des, 'DATA'));
