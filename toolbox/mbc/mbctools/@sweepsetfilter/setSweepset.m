function ssf = setSweepset(ssf, SS)
% SWEEPSETFILTER/SETSWEEPSET sets the sweepset in the sweepsetfilter and carries out the required updates

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:12:16 $

% If this sweepsetfilter is already an original then set the data
if isOriginal(ssf)
	ssf.pSweepset.info = SS;
% If this sweepsetfilter has an invalid pointer then create a new one
elseif ~isvalid(ssf.pSweepset)
	ssf.pSweepset = xregpointer(SS);
end    

ssf = updateAll(ssf);

% Ensure everyone knows that it's all been changed
queueEvent(ssf, 'allsweepsetevents');