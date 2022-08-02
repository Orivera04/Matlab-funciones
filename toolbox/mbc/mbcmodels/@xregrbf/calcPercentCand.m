function PercentCandidates = calcPercentCand(m,PcCandStr,nObs)
%CALCPERCENTCAND

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:22 $

% calculates the percentage of data points taken as centers given an xregoptmgr evalstr 
% supports the old version when PcCandStr is a double

if isa(PcCandStr,'double')
	PercentCandidates = PcCandStr;
else
	try
		PercentCandidates = eval(PcCandStr{1});
	catch
		PercentCandidates = eval(PcCandStr{2});
		warning(['Invalid expression for PercentCandidates - using default ',PcCandStr{2}])
	end
end
