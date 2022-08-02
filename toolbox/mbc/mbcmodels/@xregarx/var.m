function varargout= var(m,varargin);
%XREGARX/VAR pev variance info storage and retrieval

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:46 $

if nargin==1
   [varargout{1:nargout}]= var(m.StaticModel);
else
   m.StaticModel= var(m.StaticModel,varargin{:});
   varargout{1}= m;
end

   
