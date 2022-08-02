function d = pr_ChangeView(d,ID,setup)
%d = pr_ChangeView(d,ID,setup)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.3 $  $Date: 2004/02/09 08:22:18 $

oldID = d.ViewInfo(d.currentviewinfo).ID;
pindex = strmatch(ID,{d.ViewInfo.ID},'exact');
if length(pindex)~=1
    error('Cannot find view ID');
end
page = d.ViewInfo(pindex);
if strcmp(oldID, 'plot') && d.Plot.DoColor
    % Force color by value off - Leave this on, and it screws up afterwards
    plcb = plot(d.nd, 'get_callbacks');
    feval(plcb.ColorSelector, d.Handles.plm.DoColor(2), [], 'switch');
    d = pr_GetViewData;
end
if ~isempty(page.button)
    % reflect current view on toggle buttons
    %  first turn off redraw
    d.Handles.ViewToolbar.setRedraw(false);
    set(d.Handles.ViewToggle,'state','off');
    set(d.Handles.ViewToggle(page.button),'state','on');
    % (redraw turned back on later)
end

% Resize bottom card for table view
if strcmp(ID, 'table')
    set(d.Handles.SplitLayout, 'split', [0.35 0.65]);   
elseif strcmp(oldID, 'table')
    set(d.Handles.SplitLayout, 'split', [0.65 0.35]);  
end

% display blank while switching views
PR=xregGui.PointerRepository;
ID=PR.stackSetPointer(d.Handles.Figure, 'watch');

d.currentviewinfo = pindex;

% Check for special - needs another card
if ischar(page.card)
    f = strmatch(page.card,{d.ViewInfo.ID},'exact');
    if length(f)==1
        d.ViewInfo(pindex).card = d.ViewInfo(f).card;
        page.card = d.ViewInfo(f).card;
        % This card drawn?
        if ~d.ViewInfo(f).drawn & ~isempty(d.ViewInfo(f).drawcb)
            [d,lyt] = feval(d.ViewInfo(f).drawcb,d);
            if ~d.ViewInfo(f).dialog && ~isempty(lyt)
                % Blank out the pane when a new view is created
                pr_Message(d,'');
                attach(d.Handles.TopCard, lyt, d.ViewInfo(f).card);
                set(d.Handles.TopCard,'packstatus','on');%  ?? required?
            end
            d.ViewInfo(f).drawn = 1;
        end
    else
        error('cannot find card');
    end
end



% View drawn yet?
if ~page.drawn & ~isempty(page.drawcb)
    [d,lyt] = feval(page.drawcb,d);
    if ~page.dialog && ~isempty(lyt)
        attach(d.Handles.TopCard, lyt, page.card);
        set(d.Handles.TopCard,'packstatus','on');%  ?? required?
    end
    d.ViewInfo(pindex).drawn = 1;
end

if page.dialog
    if isempty(d.OldViewID)
        % Only update this if not switching between dialog views
        d.OldViewID = oldID;
    end
else
    d.OldViewID = [];
end
d.currentcard = page.card;
d.CB.View = page.view;
d.Exprs.plot_index = [];

% RESTORE THIS SECTION OF CODE WHEN SCRIPT FUNCTIONALITY IS INSTALLED
% if ~page.dialog
%     if d.Script.ShowScript
%         set(d.Handles.BottomCard,'currentcard',3);
%     elseif page.bmlist
%         set(d.Handles.BottomCard,'currentcard',1);
%     else
%         set(d.Handles.BottomCard,'currentcard',2);
%     end
% end

if ~page.dialog
    if page.bmlist
        set(d.Handles.BottomCard,'currentcard',1);
    else
        set(d.Handles.BottomCard,'currentcard',2);
    end
end

% show page (set up call)
if ~isempty(page.show)
    d = feval(page.show,d);
end
% show new view (unless just setting up)
if nargin<3
    d = view(d.nd,d.CGBH,d);
end

PR.stackRemovePointer(d.Handles.Figure, ID);
d.Handles.ViewToolbar.setRedraw(true);
d.Handles.ViewToolbar.drawToolBar;
% Clear interupt flag for activeX controls
cgdatasetnodecb('clear');
