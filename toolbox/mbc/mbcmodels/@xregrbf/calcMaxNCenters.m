function maxncenters = calcMaxNCenters(m,maxCStr,nObs)
%CALCMAXNCENTERS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:21 $

% calculates the maximum number of centers, given an xregoptmgr evalstr 
% supports the old version when evalstr is a double

if isa(maxCStr,'double')
	maxncenters= maxCStr;
else
	try
		maxncenters = eval(maxCStr{1});
	catch
		maxncenters = eval(maxCStr{2});
		warning(['Invalid expression for MaxNCenters - using default ',maxCStr{2}])
	end
end
% round to the nearest integer, and ensure it is greater than one and less than N
maxncenters = min(max(round(maxncenters),1),nObs); 
