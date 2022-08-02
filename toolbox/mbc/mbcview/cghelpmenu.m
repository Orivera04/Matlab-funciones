function h=cghelpmenu(fig,extras)
%CGHELPMENU Add a help menu to a figure
%
%  CGHELPMENU(FIG) adds a MBC help menu to the figure fig.
%
%  CGHELPMENU(FIG,str) where str is a M*2 cell array of strings and
%  corresponding help destination codes adds M additional entries to the
%  Help menu with callbacks pointing to the correct destination.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.3 $  $Date: 2004/04/04 03:36:48 $

if nargin>1
    % create menu items
    h = i_createmenus(fig,extras);
else
    h = i_createmenus(fig,{});
end



function hm = i_createmenus(fig,extras)

% search for pre-existing one to alter
hm = findobj(fig,'type','uimenu','tag','Cage_Help');
cbfcn = @i_helpCB;

if isempty(hm)
    % Top level "Help" on menu bar
    hm = uimenu('parent',fig,'label','&Help','interruptible','off','tag','Cage_Help');

    % Add basic help entry
    acc = uimenu('parent',hm,'label','MBC &Help',...
        'callback',{cbfcn,''},...
        'interruptible','off');

    % add any extras
    if nargin>1
        for n = 1:size(extras,1)
            uim = uimenu('parent',hm,'label',extras{n,1},...
                'interruptible','off','callback',{cbfcn,extras{n,2}});
            if n==1
                set(uim,'separator','on');
                acc = uim;
            end
        end
    end

    % add about box link
    uimenu('parent',hm,'label','&About MBC',...
        'callback','cg_about;','separator','on','interruptible','off');

    set(acc,'accelerator','H');

else
    % alter current menu list
    hc = get(hm,'children');
    if nargin<2
        extras = {};
    end

    % first and last are standard ones.  Any central ones are center options
    numnow = (length(hc)-2);
    numwant = size(extras,1);

    if numnow>numwant
        % delete some menus
        delete(hc((end-(numnow-numwant)):(end-1)));
        hc = get(hm,'children');
    elseif numnow<numwant
        % add some menus
        for n=1:(numwant-numnow)
            uimenu('parent',hm,'interruptible','off');
        end
        % reorder menus so new ones are in the middle
        hc = get(hm,'children');
        hc = hc([(numwant-numnow)+1 1:(numwant-numnow) (numwant-numnow)+2:end]);
        set(hm,'children',hc);
    end
    hc = hc(end-1:-1:2);
    % set labels, callbacks on center ones
    for n = 1:numwant
        set(hc(n),'label',extras{n,1},'callback',{cbfcn,extras{n,2}},'separator','off');
        if n==1
            set(hc(n),'separator','on');
        end
    end
    % set up accelerator
    hc = get(hm,'children');
    if numwant==0
        set(hc(end),'accelerator','H');
    else
        set(hc,'accelerator','');
        set(hc(2),'accelerator','H');
    end
end



function i_helpCB(src, evt, helpTag)
hFig = mbcfindfigure(src);
if ~isempty(hFig) && strcmp(get(hFig, 'WindowStyle'), 'modal');
    cghelptool(helpTag, hFig);
else
    cghelptool(helpTag);
end