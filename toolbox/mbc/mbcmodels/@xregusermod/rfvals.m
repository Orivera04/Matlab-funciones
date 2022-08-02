function varargout=rfvals(U,varargin);
% xregusermod/RFVALS evaluate response features and dG

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:39 $

[varargout{1:nargout}]= feval(U.funcName,U,'rfvals',varargin{:});
if isempty(varargout{1})
   % default is none
   varargout = {[],[]};
end
