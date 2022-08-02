function ts=tstart(T, level)
%TSTART

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:19:09 $

% Allows multi-level record access

if nargin < 2
	level = 1;
end

if ~isempty(T.sizes{level})
	ts = cumsum(double([1 T.sizes{level}(1:end-1)]));
else
	ts = [];
end