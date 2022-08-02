function varargout = feval(obj, varargin)
% MBCINLINE/FEVAL
%
% Faster inline object for function calls otherwise pass up to ordinary
% inline object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 06:45:10 $

if ~isempty(obj.funcHandle)
    [varargout{1:max(1,nargout)}] = feval(obj.funcHandle, varargin{:});
else
    varargout{1} = feval(obj.inline, varargin{:});
end