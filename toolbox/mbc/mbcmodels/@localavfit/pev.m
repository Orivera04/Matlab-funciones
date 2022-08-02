function [varargout]=pev(L,x,varargin);
%LOCALAVFIT/PEV evaulate pev 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:37:49 $

[varargout{1:max(nargout,1)}]=pev(L.model,x);

