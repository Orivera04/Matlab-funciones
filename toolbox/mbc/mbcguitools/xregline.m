function h=xregline(varargin)
% XREGLINE   Create a modified line object
%
%   h=xregline('prop',value,...)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:25 $

% Created 26/2/2001

h=double(xregGui.line(varargin{:}));