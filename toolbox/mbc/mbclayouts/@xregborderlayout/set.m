function  set(obj,varargin)
%  Synopsis
%     function   set(obj,parameter,value,setChildren)
%
%  Description
%     Set the parameter of the handles. This works very similar
%     to the set methods for handles. The only difference is that
%     some methods have been overloaded to peform differently
%     on the package. Non overload methods just peform the set
%     recursively on all submembers.
%
%
%  Overloaded set methods
%     POSITION :     [xmin xmax width height] of the whole package.
%     INNERBORDER :  [ west_width south_height east_width north_height ] sizes
%     LAYOUT      :  [ west_layout south_layout east_layout north_layout]
%                    eg if east_layout is 0 then the east_width is measured from
%                    the left border else the east_width is measured from the
%                    centerpoint.
%     BORDER      :  A empty buffer around container
%     CENTER      :  Center component
%     EAST        :  East component .. same for SOUTH WEST NORTH
%
%     methods xregborderlayout

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:34:47 $

norepack = 1;

if ~isa(obj,'xregborderlayout')
    builtin('set',obj,varargin{:});
else
    for arg=1:2:length(varargin)
        parameter = varargin{arg};
        value = varargin{arg+1};
        reqnorepack=0;
        switch upper(parameter)
            case 'INNERBORDER'
                obj.hGrid.RowSizes = [value(4) -1 value(2)];
                obj.hGrid.ColumnSizes = [value(1) -1 value(3)];
            case 'CENTER'
                el = get(obj.xregcontainer,'elements');
                delete(el{5});
                el{5} = value;
                [obj.xregcontainer,reqnorepack] = set(obj.xregcontainer,'elements',el);
            case 'WEST'
                p = get(value,'position');
                el = get(obj.xregcontainer,'elements');
                delete(el{4});
                el{4} = value;
                [obj.xregcontainer,reqnorepack] = set(obj.xregcontainer,'elements',el);                
                obj.hGrid.ColumnSizes(1) = p(3);  
            case 'SOUTH'
                p = get(value,'position');
                el = get(obj.xregcontainer,'elements');
                delete(el{3});
                el{3} = value;
                [obj.xregcontainer,reqnorepack] = set(obj.xregcontainer,'elements',el);                
                obj.hGrid.RowSizes(3) = p(4);  
            case 'EAST'
                p = get(value,'position');
                el = get(obj.xregcontainer,'elements');
                delete(el{2});
                el{2} = value;
                [obj.xregcontainer,reqnorepack] = set(obj.xregcontainer,'elements', el);                
                obj.hGrid.ColumnSizes(3) = p(3);  
            case 'NORTH'
                p = get(value,'position');
                el = get(obj.xregcontainer,'elements');
                delete(el{1});
                el{1} = value;
                [obj.xregcontainer,reqnorepack] = set(obj.xregcontainer,'elements',el);                
                obj.hGrid.RowSizes(1) = p(4);  
            otherwise
                [obj.xregcontainer,reqnorepack] = set(obj.xregcontainer,parameter,value);
        end
        norepack= norepack & reqnorepack;
    end

    if ~norepack && get(obj,'boolpackstatus')
        repack(obj);
    end
end
