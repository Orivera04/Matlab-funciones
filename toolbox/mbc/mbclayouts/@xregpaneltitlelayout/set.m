function  obj =set(obj,varargin)
%  Synopsis
%     function  obj = set(obj,parameter,value)
%
%  Description
%     Set the parameter of the handles. This works very similar
%     to the set methods for handles. The only difference is that
%     some methods have been overloaded to peform differently
%     on the package. Non overload methods just peform the set
%     recursively on all submembers.
%
%
%
%  Overloaded set methods
%     CENTER   :     object/layout to place in centre of frametitle
%     USERDATA    :  User-definable data store
%     VISIBLE  :   on/off
%     TITLE    :   string
%     TITLEHEIGHT  : height in pixels of title panel
%     TITLEBORDER  : innerborder of title panel
%     DIVIDER  :  on/off
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:36:40 $

% Default is to not require a repack
dorepack = 0;
if ~isa(obj,'xregpaneltitlelayout')
    builtin('set',obj,varargin{:});
    reqrepack=0;
else
    for arg=1:2:nargin-1
        parameter = varargin{arg};
        value = varargin{arg+1};
        reqrepack=1;
        switch upper(parameter)
            case 'CENTER'
                obj.xregcontainer = set(obj.xregcontainer,'elements', {value});
            case 'VISIBLE'
                ud = obj.ptr.info;
                set([obj.title; obj.ttlpanel; obj.outerpanel],'visible',value);
                if ~isempty(ud.dividerhandle)
                    set(ud.dividerhandle, 'visible', value);
                end
                cdata=get(obj.xregcontainer,'containerdata');
                % iterate over elements
                el=cdata.elements;
                for k=1:length(el)
                    set(el{k},'visible',value);
                end
                reqrepack=0;
            case 'TITLE'
                set(obj.title,'string',value);
                reqrepack=0;
            case 'TITLEHEIGHT'
                ud=obj.ptr.info;
                ud.titleheight = value;
                obj.ptr.info=ud;
                reqrepack=1;
            case 'DIVIDER'
                ud = obj.ptr.info;
                if ischar(value)
                    value = strcmp(value,'on');
                end

                ud.divider = value;
                if value && isempty(ud.dividerhandle)
                    % Construct a divider patch if necessary
                    SC = xregGui.SystemColorsDbl;
                    ud.dividerhandle = xregGui.oblong('parent', get(obj.xregcontainer, 'Parent'), ...
                        'hittest', 'off', ...
                        'layer','middle', ...
                        'visible', get(obj.outerpanel, 'visible'), ...
                        'position', [0 0 1 1], ...
                        'color', SC.CTRL_BACK);
                    connectdata(obj, ud.dividerhandle);
                else
                    delete(ud.dividerhandle);
                    ud.dividerhandle = [];
                end
                obj.ptr.info = ud;
                reqrepack = 1;
            case 'TITLEBORDER'
                ud=obj.ptr.info;
                ud.titleborder = value;
                obj.ptr.info=ud;
                reqrepack=1;
            case 'SELECTABLE'
                ud=obj.ptr.info;
                val=strcmp(value,'on');
                if val~=ud.selectmode
                    ud.selectmode=val;
                    obj.ptr.info=ud;
                    i_setcolors(obj);
                end
                reqrepack=0;
            case 'SELECTED'
                ud=obj.ptr.info;
                val=strcmp(value,'on');
                if val~=ud.selected
                    ud.selected=val;
                    obj.ptr.info=ud;
                    if ud.selectmode
                        i_setcolors(obj);
                    end
                end
                reqrepack=0;
            case 'TITLEFONTSIZE'
                set(obj.title, 'fontsize', value);
                reqrepack=0;
            case 'TITLETOOLTIPSTRING'
                set(obj.title, 'tooltipstring', value);
                if isempty(value)
                    set(obj.title, 'enable', 'inactive');
                else
                    set(obj.title, 'enable', 'on');
                end
                reqrepack=0;
            otherwise
                [obj.xregcontainer,reqrepack]=set(obj.xregcontainer,parameter,value);
                reqrepack=~reqrepack;
        end
        dorepack=(dorepack || reqrepack);
    end
end

if dorepack & getBoolPackstatus(obj.xregcontainer)
    obj = repack(obj);
end




function i_setcolors(obj)
ud=obj.ptr.info;
sc=xregGui.SystemColorsDbl;
if ud.selectmode
    if ud.selected
        set(obj.title,'foregroundcolor',sc.TITLE_ACTIVE_TEXT,'backgroundcolor',sc.TITLE_ACTIVE_BG);
        set(obj.ttlpanel,'backgroundcolor',sc.TITLE_ACTIVE_BG);
    else
        set(obj.title,'foregroundcolor',sc.TITLE_INACTIVE_TEXT,'backgroundcolor',sc.TITLE_INACTIVE_BG);
        set(obj.ttlpanel,'backgroundcolor',sc.TITLE_INACTIVE_BG);
    end
else
    set(obj.title,'foregroundcolor',[0 0 0],'backgroundcolor',sc.CTRL_BACK);
    set(obj.ttlpanel,'backgroundcolor',sc.CTRL_BACK);
end
