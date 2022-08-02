function [varargout]= nfactors(m);
%NFACTORS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:58:41 $

if nargout>=1
   [varargout{1:nargout}]= nfactors(m.mv3xspline);
else
   [varargout{1}]= nfactors(m.mv3xspline);
end
   