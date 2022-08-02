function h=xreguicontrol(varargin)
% XREGUICONTROL   Create a modified uicontrol
%
%   h=xreguicontrol('prop',value,...)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:34:41 $

% Created 26/2/2001

h=double(xregGui.uicontrol(varargin{:}));
