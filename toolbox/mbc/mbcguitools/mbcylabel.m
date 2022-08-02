function hh = mbcylabel(ax,string,varargin)
%MBCYLABEL Y-axis label.
%   MBCYLABEL(ax,'text') adds text beside the Y-axis on the specified axis.
%
%   MBCYLABEL(ax,'text','Property1',PropertyValue1,'Property2',PropertyValue2,...)
%   sets the values of the specified properties of the ylabel.
%
%   H = MBCYLABEL(...) returns the handle to the text object used as the label.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:33:28 $

h = get(ax,'ylabel');

set(h, 'string', string, varargin{:});

if nargout > 0
   hh = h;
end