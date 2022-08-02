function mbccreateaddonmenus(Tools, prnt, cbobj)
%MBCCREATEADDONMENUS Create a menus structure from a structure variable
%
%  MBCCREATEADDONMENUS(TOOLS, PARENT, CBOBJECT)  generates a multi-level menu
%  structure from the information in TOOLS, under PRNT.  CBOBJECT is an
%  object that will be provided to the enable function for each menu item
%  (see below).
%
%  TOOLS is a structure array containing the information:
%
%    TOOLS(n).Name  -  (string) Label for menu.
%    TOOLS(n).Level -  (double) "Level" of menu.  This controls the parent-child 
%                      relationships of the items.  When the level is incremented, 
%                      the new item is made a child of the previous item.
%    TOOLS(n).Separator - (0/1) indicate whether to set separator on.
%    TOOLS(n).EnableFcn - }
%    TOOLS(n).Callback -  } These two items are concatenated into a cell array of
%                           {EnableFcn,Callback} and placed in the items userdata.
%                           The information is useful in the callback function.
%
%  If CBOBJECT is omitted, the parent figure will be used by default.
%
%  PARENT may be a handle to a figure or a uimenu.  If it is a handle to a
%  figure, a "Tools" menu item will be created to house the new tools,
%  otherwise the tools will be added to the specified menu.  If no tools
%  are specifed, a parent menu will not be created.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.4 $  $Date: 2004/04/04 03:25:47 $

if length(Tools)==0
    return
end

if nargin==1
    prnt = gcf;
    cbobj = prnt;
elseif nargin==2
    % Set CBOBJECT to be the figure these menus are in
    cbobj = prnt;
    while ~strcmp(get(cbobj, 'type'), 'figure')
        cbobj = get(cbobj, 'Parent');
    end
end

% If parent is a figure, create a Tools menu
if strcmp(get(prnt, 'type'), 'figure')
    prnt = uimenu('Parent', prnt, ...
        'Label', '&Tools');
end

cbfcn = {@i_openmenu, cbobj};
i_createmenus(prnt, Tools, 0, cbfcn, 1);



function n = i_createmenus(prnt,Btools,lvl,cbfcn,n)
item = prnt;
while n<=length(Btools) && Btools(n).Level>=lvl
    if Btools(n).Level==lvl
        item = handle(uimenu('parent',prnt,...
            'label',Btools(n).Name,...
            'separator',Btools(n).Separator,...
            'callback',cbfcn,...
            'userdata',{Btools(n).EnableFcn,Btools(n).Callback}));
        n = n+1;
    else
        n = i_createmenus(item, Btools, lvl+1, cbfcn, n);
    end
end



function i_openmenu(src, evt, cbobj)
% Check enable status of any children
ch = get(src,'children');
if length(ch)
    ch_en = cell(length(ch), 1);
    ch_en(:) = {'on'};
    for n = 1:length(ch)
        ch_ud = get(ch(n),'userdata');
        if iscell(ch_ud) && ~isempty(ch_ud{1})
            enstate = feval(ch_ud{1}, cbobj);
            if ~enstate
                ch_en{n} = 'off';
            end
        end
    end
    set(ch, {'enable'}, ch_en);
end

% Execute any callback on this menu item
ud = get(src,'userdata');
if iscell(ud)
    xregcallback(ud{2},src,evt);
end
