function  res =get(obj,parameter)
%  Synopsis
%     function  res =get(obj,parameter)
%
%  Description
%     Peforms the same action as the handle graphics get function.
%     Some parameter types are overloaded however to take into account
%     object groupings.
%
%
%  See Also
%     methods xregborderlayout

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:34:45 $

switch upper(parameter)
    case 'INNERBORDER'
        res = [obj.hGrid.ColumnSizes(1) obj.hGrid.RowSizes(3) obj.hGrid.ColumnSizes(3) obj.hGrid.RowSizes(1)];
    case 'NORTH'
        el = get(obj.xregcontainer,'elements');
        res = el{1};
    case 'EAST'
        el = get(obj.xregcontainer,'elements');
        res = el{2};
    case 'WEST'
        el = get(obj.xregcontainer,'elements');
        res = el{4};
    case 'SOUTH'
        el = get(obj.xregcontainer,'elements');
        res = el{3};
    case 'CENTER'
        el = get(obj.xregcontainer,'elements');
        res = el{5};
    otherwise
        res = get(obj.xregcontainer,parameter);
end
