% FASTFIND  Fast index finder
%
%   IND=FASTFIND(LIST,POINTS) looks up each element of POINTS
%   in LIST and returns its index in LIST in the output INDS.
%   LIST must be a uint32 vector, POINTS must be a double vector.
%   INDS is a double vector the same size as POINTS.  If any
%   elements of POINTS are not found in LIST, the corresponding
%   entry in IND is set to NaN.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:29 $

% Created 3/5/2000
