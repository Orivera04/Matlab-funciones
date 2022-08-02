function  varargout= var(m,varargin)
%var pev info store

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:00:41 $

if nargin==1
    [varargout{1:3}]= var(m.mv3xspline);
else
    m.mv3xspline= var(m.mv3xspline,varargin{:});
    varargout{1}= m;
end