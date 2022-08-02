function s= statistics(T);
% MDEVPROJECT/STATISTICS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:08:22 $

f= factors(T);
if IsMatched(T)
	X= getdata(T,'X');
	if iscell(X)
		X= X{1};
	end
	sd= size(X);
	sd(2)= length(f);
else
	
	des= T.DesignDev(end).design;
	sd= [0 length(f) size(des,1)];
end

s= [length(T.DesignDev) sd];
