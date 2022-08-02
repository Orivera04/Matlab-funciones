function hh = mbcxlabel(ax,string,varargin)
%MBCXLABEL X-axis label.
%   MBCXLABEL(ax,'text') adds text beside the X-axis on the specified axis.
%
%   MBCXLABEL(ax,'text','Property1',PropertyValue1,'Property2',PropertyValue2,...)
%   sets the values of the specified properties of the xlabel.
%
%   H = MBCXLABEL(...) returns the handle to the text object used as the label.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:33:27 $

h = get(ax,'xlabel');

set(h, 'string', string, varargin{:});

if nargout > 0
   hh = h;
end
