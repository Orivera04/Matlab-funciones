function S=type(T, level);
%TYPE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:19:10 $

% Allows multi-level record access

if nargin < 2
	level = 1;
end

S= T.type{level};