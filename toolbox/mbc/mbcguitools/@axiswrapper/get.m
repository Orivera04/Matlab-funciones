function  res =get(obj,parameter)
%  Synopsis
%     function  res =get(obj,parameter)
%
%  Description
%     Peforms the same action as the handle graphics get function.
%     Some parameter types are overloaded however to take into account
%     object groupings.
%
%  Overload get methods
%     POSITION : The position of the axis.
%
%  Example
%
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:17:59 $

data=obj.g.info;

if nargin==1
    res = strvcat(...
        '            enable',...
        '            handle',...
        '            [any other axes properties]');
    return;
end

switch lower(parameter)
    case 'position'
        res = get(data.axes, 'position')- [data.border(1:2) -(data.border(1:2)+data.border(3:4))];
    case 'enable'
        res='on';
    case 'handle'
        res= data.axes;
    case 'border'
        res = data.border;
    otherwise
        res = get(data.axes,parameter);
end