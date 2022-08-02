function ssf = create(ssf)
% SWEEPSETFILTER/CREATE ensures that the sweepsetfilter points to a valid heap position
%
% If the object already points to a valid heap position nothing happens

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:08:41 $

if ~isvalid(ssf.pSweepset)
	ssf.pSweepset = xregpointer(sweepset);
end
