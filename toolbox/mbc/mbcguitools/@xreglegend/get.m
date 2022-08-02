function out=get(obj,property)
%  xreglegend/GET   Set interface for xreglegend object
%
%   Valid properties are:
%     'Position'  -  4 element position vector in pixels

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:31:42 $

%  Written by: Mungo Stacy
%       11/6/01

% Bail if we've not been given an xreglegend object
if ~isa(obj,'xreglegend')
    error('Cannot set properties: not a xreglegend object!')
end

out = [];
obj = get(obj.axes,'userdata');
switch lower(property)
case 'position'
    vis=get(obj.axes,'visible');
    switch vis
    case 'off'
        out = obj.pos;
    case 'on'
        out=get(obj.axes,'position');
    end
case 'axes'
    out = obj.axes;
end

return

