function hh = mbczlabel(ax,string,varargin)
%MBCZLABEL X-axis label.
%   MBCZLABEL(ax,'text') adds text beside the Z-axis on the specified axis.
%
%   MBCZLABEL(ax,'text','Property1',PropertyValue1,'Property2',PropertyValue2,...)
%   sets the values of the specified properties of the zlabel.
%
%   H = MBCZLABEL(...) returns the handle to the text object used as the label.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:33:29 $

h = get(ax,'zlabel');

set(h, 'string', string, varargin{:});

if nargout > 0
   hh = h;
end