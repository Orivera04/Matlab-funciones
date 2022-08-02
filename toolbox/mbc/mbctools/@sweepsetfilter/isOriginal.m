function OK = isOriginal(ssf)
% SWEEPSETFILTER/ISORIGINAL returns true if this sweepsetfilter points to a sweepset

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:08:58 $

% A sweepsetfilter is original if the pointer isn't valid
OK = ~isvalid(ssf.pSweepset) || isa(ssf.pSweepset.info, 'sweepset');
