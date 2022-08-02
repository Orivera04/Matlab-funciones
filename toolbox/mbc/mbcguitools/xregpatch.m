function h=xregpatch(varargin)
% XREGPATCH   Create a modified patch object
%
%   h=xregpatch('prop',value,...)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:32 $

% Created 26/2/2001

h=double(xregGui.patch(varargin{:}));