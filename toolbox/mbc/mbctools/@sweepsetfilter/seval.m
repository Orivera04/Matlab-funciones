function T = seval(f,obj,varargin);
%SEVAL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:12:18 $

T = seval(f, sweepset(obj), varargin{:});