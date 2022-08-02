function maxnparams = calcMaxNParams(m,maxPStr,nObs)
%CALCMAXNPARAMS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:48:00 $

% calculates the maximum number of parameters, given an xregoptmgr evalstr 
% supports the old version when evalstr is a double

if isa(maxPStr,'double')
	maxnparams= maxPStr;
else
	try
		maxnparams = eval(maxPStr{1});
	catch
		maxnparams = eval(maxPStr{2});
		warning(['Invalid expression for MaxNParams - using default ',maxPStr{2}])
	end
end
% round to the nearest integer, and ensure it is greater than one and less than N
maxnparams = min(max(round(maxnparams),1),nObs); 
