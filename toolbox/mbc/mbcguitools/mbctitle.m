function hh = mbctitle(ax,string,varargin)
%MBCTITLE Graph title.
%   MBCTITLE(ax,'text') adds text at the top of the current axis.
%
%   MBCTITLE(ax,'text','Property1',PropertyValue1,'Property2',PropertyValue2,...)
%   sets the values of the specified properties of the title.
%
%   H = MBCTITLE(...) returns the handle to the text object used as the title.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:33:26 $


h = get(ax,'title');

set(h, 'string', string, varargin{:});

if nargout > 0
   hh = h;
end