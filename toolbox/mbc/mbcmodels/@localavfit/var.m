function varargout= var(L,varargin);
%LOCALAVFIT/VAR pev variance info storage and retrieval

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:37:58 $

if nargin==1
   [varargout{1:nargout}]= var(L.model);
else
   L.model= var(L.model,varargin{:});
   varargout{1}= L;
end

   
