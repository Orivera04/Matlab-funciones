function s= tsizes(T,level, AsUInt32);
%TSIZES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:19:08 $

% Allows multi-level record access

if nargin < 2
	level = 1;
end

if nargin < 3
	AsUInt32 = 0;
end

if AsUInt32
	s = T.sizes{level};
else
	s = double(T.sizes{level});
end