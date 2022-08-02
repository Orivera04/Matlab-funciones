function varargout= var(L,varargin);
%LOCALMULTI/VAR pev variance info storage and retrieval

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:40:16 $

m= get(L,'currentmodel');
if nargin==1
   [varargout{1:nargout}]= var(m);
else
   m= var(m,varargin{:});
   set(L,'currentmodel',m);
   varargout{1}= L;
end

   
