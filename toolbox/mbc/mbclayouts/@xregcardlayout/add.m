function varargout=add(varargin)
% ADD  Overloaded method
%
%   This function is not supported with xregcardlayouts.  Objects
%   must be added removed using ATTACH and DETACH.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:49 $


error(['This function is not supported for xregcardlayouts.  Use ATTACH ',...
      sprintf('\n') 'and DETACH to add/remove objects to/from xregcardlayouts.']);
varargout=repmat({[]},1,nargout);