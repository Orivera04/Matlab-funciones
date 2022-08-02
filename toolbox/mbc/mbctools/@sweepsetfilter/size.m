function s = size(obj, varargin);
%SIZE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:12:19 $

s = size(sweepset(obj), varargin{:});