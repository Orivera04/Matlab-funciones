function OK = isSubset(D1, D2, KEEP_SWEEP_ORDER);
% SWEEPSET/ISSUBSET if all data from D2

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 08:06:32 $

s1= size(D1);
s2= size(D2);

% MAke sure that D1 has fewer sweeps than D2 and contains the same testnums
sok =  s1(3)<=s2(3)  &  all( ismember(testnum(D1),testnum(D2)) );
% 
varInd= find(D2,get(D1,'name'));

OK=0;
if sok & ~isempty(varInd);
	if nargin < 3 | ~KEEP_SWEEP_ORDER
		T1= testnum(D1);
		T2= testnum(D2);
		% Duplicate testnums will throw this so return if duplicates found
		if length(unique(T2)) ~= length(T2)
			return
		end
		
		SInd= zeros(1,length(T1));
      [tnumSort,tnumInd]= sort(T2);
		for i=1:length(T1)
         tmp= mbcbinsearch(tnumSort,T1(i));
			SInd(i)= tnumInd(tmp);
		end
	else
		SInd = ':';
	end
	
	S  = substruct('()' , {':',varInd,SInd} );
	D2 = subsref(D2, S);
	
	% Need to replace NaN in data fields so that isequal does not fail on
	% NaN ~= NaN
% 	D1.data(isnan(D1.data)) = inf;
% 	D2.data(isnan(D2.data)) = inf;
	
	OK = isequal(tsizes(D2), tsizes(D1)) & isidentical(D2.data, D1.data);
end

