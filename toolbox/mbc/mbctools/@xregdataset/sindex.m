function ind= sindex(S,i,level);
% DATASET/SINDEX data indices to sweep i
% 
% ind= sindex(S,i);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:19:03 $

% This function is almost identical to RecPos .. See notes for RecPos
if nargin < 3
	level = 1;
end

ind = GetRecPos(S.sizes{level}, uint32(i));