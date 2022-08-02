function  obj =set(obj,varargin)
%  Synopsis
%     function  obj = set(obj,parameter,value,setChildren)
%
%  Description
%     Set the parameter of the handles. This works very similar
%     to the set methods for handles. The only difference is that
%     some methods have been overloaded to peform differently
%     on the package. Non overload methods just peform the set
%     recursively on all submembers.
%
%  Overloaded set methods
%     POSITION :     [xmin xmax width height] of the whole package.
%     INNERBORDER  : [NORTH EAST SOUTH WEST] inner border in pixels
%     CENTER   :     object/layout to place in centre of frametitle
%     OUTERBORDER  : [NORTH EAST SOUTH WEST] outer border in pixels
%                    Note this property is obsolete: use the container
%                    BORDER property instead.
%     USERDATA    :  User-definable data store
%     STATE       :  'out'/{'in'}

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:35 $

dorepack = 1;
if ~isa(obj,'xregpanellayout')
    builtin('set',obj,varargin{:});
    reqrepack=0;
else
    cdata=get(obj.xregcontainer,'containerdata');
    for arg=1:2:nargin-1
        parameter = varargin{arg};
        value = varargin{arg+1};
        reqrepack=1;
        switch upper(parameter)
            case 'POSITION'
                value(3:4) = max(value(3:4),[1 1]);
                value=round(value);
                cdata.position=value;
            case 'INNERBORDER'
                ud=obj.rtP.info;
                if isnumeric(value) & length(value)==4
                    ud.borders=[value(4) value(3) -(value(2)+value(4)) -(value(1)+value(3))];
                end
                obj.rtP.info=ud;
            case 'OUTERBORDER'
                value=value(end:-1:1);
                cdata.border=value;
            case 'CENTER'
                cdata.elements={value};
            case 'VISIBLE'
                set(obj.panel,'visible',value);
                % iterate over elements
                el=cdata.elements;
                for k=1:length(el)
                    set(el{k},'visible',value);
                end
                reqrepack=0;
            case 'ENABLE'
                if ~any(strcmp(lower(value),{'off','on','inactive'}))
                    error('Bad value for framepanellayout property: Enable');
                end
                % iterate over elements
                el=cdata.elements;
                for k=1:length(el)
                    set(el{k},'enable',value);
                end
                reqrepack=0;
            case 'USERDATA'
                ud=obj.rtP.info;
                % overloaded: can use a frame object as store
                ud.userdata=value;
                obj.rtP.info=ud;
                reqrepack=0;
            case 'STATE'
                set(obj.panel, 'type', lower(value));
                reqrepack=0;
            otherwise
                [obj.xregcontainer,reqrepack]=set(obj.xregcontainer,parameter,value);
                reqrepack=~reqrepack;
        end
        dorepack=(dorepack || reqrepack);
    end
end

if dorepack & getBoolPackstatus(obj.xregcontainer) 
    repack(obj);
end
