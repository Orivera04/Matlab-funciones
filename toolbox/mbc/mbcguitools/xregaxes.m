function h=xregaxes(varargin)
% XREGAXES   Create a modified set of axes
%
%   h=xregaxes('prop',value,...)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:16 $

% Created 26/2/2001

h=double(xregGui.axes(varargin{:}));
