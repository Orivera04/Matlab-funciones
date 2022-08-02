function out = filter(obj, varargin)
%FILTER

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:08:46 $

out = filter(sweepset(obj), varargin{:});

