function [A,p]= SweepPos(A,RecInd)
% DATASET/SWEEPPOS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:19:06 $

% This version supports multi-level sweep access and calls
% private mex function GetSweepPos to return the valid sweep sizes

if islogical(RecInd)
   RecInd= find(RecInd);
else
   RecInd = double(sort(RecInd));
end

for i = 1:length(A.sizes)
	if ~isempty(RecInd) & ~isempty(A.sizes{i})
		newsizes = GetSweepPos(A.sizes{i}, RecInd);
		p = newsizes~=0;
		A.sizes{i}   = newsizes(1,p);
	else
		p=zeros(1,0);
		A.sizes{i}= p;
	end
	A.type{i}    = A.type{i}(1,p);
	A.testnum{i} = A.testnum{i}(1,p);
end
