function newssf = copy(ssf)
% SWEEPSETFILTER/COPY makes a deep copy of the sweepsetfilter, including the parent if it is a sweepset

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:08:40 $

% Make sure that newssf has the correct pointers if the input has a null pointer
newssf = create(ssf);

% If ssf is an original then duplicate the sweepset as well
if isOriginal(ssf)
	newssf.pSweepset = xregpointer(ssf.pSweepset.info);
end