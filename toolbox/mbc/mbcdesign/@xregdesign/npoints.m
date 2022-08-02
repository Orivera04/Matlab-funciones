function n=npoints(des)
% DESIGN/NPOINTS  Number of design points
%   N=NPOINTS(D) returns the number of design points
%   in the design D.  The number of points is not
%   resettable via this method: see AUGMENT, REINIT for
%   expanding the design.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:16 $

% Created 4/11/99

n=des.npoints;

return