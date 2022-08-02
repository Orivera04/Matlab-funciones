function h=xregDialog(varargin)
%XREGDIALOG
%
%  h=xregDialog(prop,value...) creates a modified invisible figure window
%  and returns the UDD handle to it.  

%  SEE ALSO:  XREGFIGURE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:34:20 $


h = xregGui.figure(varargin{:}, 'visible', 'off', 'windowstyle', 'modal');