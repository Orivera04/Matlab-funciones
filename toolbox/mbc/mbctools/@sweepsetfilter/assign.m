function newssf = assign(ssf, ssf1)
%ASSIGN

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:08:37 $

newssf = ssf1;

% If ssf is an original then duplicate the sweepset as well
if isOriginal(ssf1)
	newssf.pSweepset = ssf.pSweepset;
    if ~(isvalid(ssf.pSweepset) && isequal(ssf.pSweepset.info, ssf1.pSweepset.info))
        newssf.pSweepset.info = ssf1.pSweepset.info;
    end
end	