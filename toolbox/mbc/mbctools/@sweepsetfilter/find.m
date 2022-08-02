function [ind, varargout] = find(obj, varargin)
%FIND

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:08:47 $

% No need to filter out records for a find operation, so only apply variables
sweepset = applyVariables(obj);
[ind, varargout{1:nargout-1}] = find(sweepset, varargin{:});