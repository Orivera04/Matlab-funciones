function  obj = set(obj,varargin)
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
%
%  Overloaded set methods
%     POSITION :     [xmin xmax width height] of the whole package.
%     SPLIT    :     [lfraction rfraction]
%     ORIENTATION :  'lr', 'ud'  sets the split orientation
%     STYLE    :     {'toleft','totop'}/{'toright'/'tobottom'}/{'leftright','topbottom'}
%     SNAPSTYLE:     'tozero'/'tominimum'
%     CALLBACK :     Callback string executed after a resize
%     LEFT/TOP :     set object in left/top pane
%     RIGHT/BOTTOM : set object in right/top pane
%     LEFTINNERBORDER } [N E S W] inner border for left/top pane
%     TOPINNERBORDER  }
%     RIGHTINNERBORDER  } [N E S W] inner border for right/bottom pane
%     BOTTOMINNERBORDER }
%     MINWIDTH   :   [lmin rmin] set a minimum size for each pane in the
%                    splitlayout.
%     MINWIDTHUNITS : Units for minimum width settings: either 'pixels'
%                     or 'normalized'.
%     STATE      :   {'left','top'}/{'right','bottom'}/'center'
%     ENABLE     :   'on'/'off'
%     SPLITENABLE:   'on'/'off'  Enable/disable the splitterbar only

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:36:59 $


norepack = 1;
if ~isa(obj,'xregsnapsplitlayout')
    builtin('set',obj,varargin{:});
else
    ud=get(obj.xregcontainer,'userdata');
    for arg=1:2:nargin-1
        parameter = varargin{arg};
        value = varargin{arg+1};
        reqnorepack=0;
        switch upper(parameter)
            case 'POSITION'
                position=value;
                position(3:4)=max([1 1],position(3:4));
                set(obj.xregcontainer,'position',position);
                position=get(obj.xregcontainer,'innerposition');
                % check new position against minimum split positions
                minw=ud.minwidth;
                if ud.snapposition || ~ud.state  % don't need checks if we are snapped to side at [0 1]
                    if any(minw)
                        if ud.orientation
                            sz=position(4);
                        else
                            sz=position(3);
                        end
                        % check to see if split needs changing
                        if strcmp(ud.minwidthunits,'normalized')
                            minw=minw.*sz;
                        end
                        newspl=ud.split.*sz;

                        violation=newspl<minw;
                        if any(violation) && ~all(violation)
                            pane=find(violation);
                            otherpane=find(~violation);
                            ud.split(pane)=minw(pane)./sz;
                            ud.split(otherpane)=1-ud.split(pane);
                        end
                    end
                end
            case 'SPLIT'
                % normalise values
                value=value./sum(value);
                % check against minwidth property
                if ud.snapposition || ~ud.state  % don't need checks if we are snapped to side at [0 1]
                    minw=ud.minwidth;
                    if any(minw)
                        pos=get(obj.xregcontainer,'innerposition');
                        if ud.orientation
                            sz=pos(4);
                        else
                            sz=pos(3);
                        end
                        % check to see if split needs changing
                        if strcmp(ud.minwidthunits,'pixels')
                            minw=minw./sz;
                        end

                        violation=value<minw;
                        if any(violation) && ~all(violation)
                            pane=find(violation);
                            otherpane=find(~violation);
                            value(pane)=minw(pane);
                            value(otherpane)=1-value(pane);
                        end
                    end
                end
                if ud.state==0
                    ud.split=value;
                end
                ud.splitmem=value;
            case 'ORIENTATION'
                if strcmp(lower(value),'lr')
                    ud.orientation=0;
                elseif strcmp(lower(value),'ud')
                    ud.orientation=1;
                end
                set(ud.rsbutton,'orientation',value);
            case 'STYLE'
                switch lower(value)
                    case {'toleft','totop'}
                        ud.behaviour=0;
                    case {'toright','tobottom'}
                        ud.behaviour=2;
                    case {'leftright','topbottom'}
                        ud.behaviour=1;
                end
                i_doimages(obj,ud);
            case 'STATE'
                % check the asked-for state is allowed by the style
                newst=ceil((strmatch(lower(value),['center';'left  ';'top   ';'right ';'bottom'])-1).*0.5);
                if isempty(newst)
                    error('mbc:xregsnapsplitlayout:InvalidArgument', ...
                        'Invalid snapsplitlayout state setting.');
                end
                if (ud.behaviour==0 && newst==2) || (ud.behaviour==2 && newst==1)
                    error('mbc:xregsnapsplitlayout:InvalidArgument', ...
                        'Snapsplitlayout state is not allowed by the current style.');
                end
                % move to state
                if newst~=ud.state
                    switch newst
                        case 0
                            newspl=ud.splitmem;
                        case 1
                            newspl=[0 1];
                        case 2
                            newspl=[1 0];
                    end
                    if ud.snapposition || ~newst  % don't need checks if we are snapped to side at [0 1]
                        % check against minwidth property
                        minw=ud.minwidth;
                        if any(minw)
                            pos=get(obj.xregcontainer,'innerposition');
                            if ud.orientation
                                sz=pos(4);
                            else
                                sz=pos(3);
                            end
                            % check to see if split needs changing
                            if strcmp(ud.minwidthunits,'pixels')
                                minw=minw./sz;
                            end

                            violation=newspl<minw;
                            if any(violation) && ~all(violation)
                                pane=find(violation);
                                otherpane=find(~violation);
                                newspl(pane)=minw(pane);
                                newspl(otherpane)=1-newspl(pane);
                            end
                        end
                    end
                    if newst
                        % turn snapped-to-side component invisible
                        if any(newspl==0)
                            el=get(obj.xregcontainer,'elements');
                            if length(el)>=newst
                                set(el{newst},'visible','off');
                            end
                        end
                    else
                        % if old split was at zero then turn component back on
                        if any(ud.split==0)
                            el=get(obj.xregcontainer,'elements');
                            if length(el)>=ud.state
                                set(el{ud.state},'visible','on');
                            end
                        end
                    end

                    ud.state=newst;
                    ud.split=newspl;
                    i_doimages(obj,ud);
                end
            case 'SNAPSTYLE'
                newset=strmatch(lower(value),['tozero   ';'tominimum'])-1;
                if ~isempty(newset) && newset~=ud.snapposition
                    ud.snapposition=newset;
                    if ud.state
                        newspl=[0 0];
                        newspl(ud.state)=1;
                        if ud.snapposition  % don't need checks if we are snapped to side at [0 1]
                            % check against minwidth property
                            minw=ud.minwidth;
                            if any(minw)
                                pos=get(obj.xregcontainer,'innerposition');
                                if ud.orientation
                                    sz=pos(4);
                                else
                                    sz=pos(3);
                                end
                                % check to see if split needs changing
                                if strcmp(ud.minwidthunits,'pixels')
                                    minw=minw./sz;
                                end
                                violation=newspl<minw;
                                if any(violation) && ~all(violation)
                                    pane=find(violation);
                                    otherpane=find(~violation);
                                    newspl(pane)=minw(pane);
                                    newspl(otherpane)=1-newspl(pane);
                                end
                            end
                        end
                        ud.split=newspl;
                    else
                        reqnorepack=1;
                    end
                else
                    reqnorepack=1;
                end
            case 'CALLBACK'
                ud.callbackstr=value;
                reqnorepack=1;
            case {'LEFT','TOP'}
                replace(obj.xregcontainer,value,1);
            case {'RIGHT','BOTTOM'}
                replace(obj.xregcontainer,value,2);
            case {'LEFTINNERBORDER','TOPINNERBORDER'}
                if isnumeric(value) && length(value(:))==4
                    ud.innerborders(1,:)=value(:)';
                end
            case {'RIGHTINNERBORDER','BOTTOMINNERBORDER'}
                if isnumeric(value) && length(value(:))==4
                    ud.innerborders(2,:)=value(:)';
                end
            case 'VISIBLE'
                set(ud.rsbutton,'visible',value);
                if strcmp(value,'on')
                    ud.visible=1;
                else
                    ud.visible=0;
                end
                % iterate over elements
                el=get(obj.xregcontainer,'elements');
                for k=1:length(el)
                    if ud.split(k)
                        set(el{k},'visible',value);
                    end
                end
                reqnorepack=1;
            case 'MINWIDTH'
                ud.minwidth=value;
            case 'MINWIDTHUNITS'
                if any(strcmp(value,{'pixels','normalized'}))
                    if ~strcmp(value,ud.minwidthunits)
                        ud.minwidthunits=value;
                        % convert minwidth values
                        pos=get(obj,'innerposition');
                        if ud.orientation
                            pos=pos(4);
                        else
                            pos=pos(3);
                        end
                        if strcmp(ud.minwidthunits,'pixels')
                            ud.minwidth=ud.minwidth.*pos;
                        else
                            ud.minwidth=ud.minwidth./pos;
                        end
                    end
                end
            case 'ENABLE'
                set(ud.rsbutton,'enable',value);
                [obj.xregcontainer, reqnorepack] = set(obj.xregcontainer,parameter,value);
            case 'SPLITENABLE'
                set(ud.rsbutton,'enable',value);
                reqnorepack=1;
            case 'BARSTYLE'
                if value~=ud.barstyle
                    ud.barstyle=value;
                    props=get(ud.rsbutton);
                    if value==0
                        rsb=xregGui.SplitterBar(props);
                    elseif value==1
                        rsb=xregGui.SplitterBar2(props);
                    end
                    delete(ud.rsbutton);
                    ud.rsbutton=rsb;
                    connectdata(obj, rsb);
                else
                    reqnorepack=1;
                end
            otherwise
                [obj.xregcontainer, reqnorepack] = set(obj.xregcontainer,parameter,value);
        end
        norepack=(norepack & reqnorepack);
    end
end
set(obj.xregcontainer,'userdata',ud);

if ~norepack &&  get(obj.xregcontainer,'boolpackstatus')
    repack(obj);
end



function i_doimages(obj,ud)
switch ud.state
    case 0
        switch ud.behaviour
            case 0
                st='l';
            case 1
                st='lr';
            case 2
                st='r';
        end
    case 1
        st='r';
    case 2
        st='l';
end
if ud.orientation
    % convert to u/d
    opts={'u','d','ud'};
    st=opts{strmatch(st,['l ';'r ';'lr'],'exact')};
end
set(ud.rsbutton,'style',st);
