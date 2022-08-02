function n = NumRecs(D, sweeps, level)
%NUMRECS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:18:46 $

if nargin < 3
	level = 1;
end
s = double(D.sizes{level});

n = sum(s(sweeps));
