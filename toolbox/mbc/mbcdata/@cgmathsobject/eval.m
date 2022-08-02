function varargout = eval(x,str,varargin)
%EVAL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:50:00 $

% direct evaluation of the functions held inside the cgmathsobject directory

[varargout{1:nargout}] = feval(str,varargin{1:length(varargin)});

return