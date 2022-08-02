function d = pHistoryManager( pFN, d, action, varargin )
%PHISTORYMANAGER Looks after the display of the features history
%
%  VIEWDATA = PHISTORYMANAGER( NODE, VIEWDATA, ACTION, <ARGS> )
%
%  ACTIONS
%   DRAWLIST - Clears the list, and then adds all the history items, then
%           REFRESHDETAILS. (Called by cgfeaturenode/view)
%
%   REFRESHDETAILS - Make sure the details pane is correct (string, color,
%            enabled)
%
%   DETAILSEDIT - Updates history from new string in details pane
%
%   ADD - Adds a new history item, and then call DRAWLIST
%
%   REMOVE - Removes history itemm then call DRAWLIST, then set selects
%             correct item
%
%   RENAME - Takes 4th argument - the new name.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:24:04 $

sc = xregGui.SystemColorsDbl;
pF = pFN.getdata;
Selected = i_getSelectedItem( d );
H = pF.get('History');
lengthH =length(H);

switch action
    case 'drawlist'
        List = d.Handles.History.ListItems;
        % clear the list first
        List.Clear;
        % Fill the history box
        if ~isempty(H)
            set(d.Handles.HistoryDelete,'enable','on');
            set(d.Handles.History,'enabled',1);
            latestHistoryItem = [];
            for ind = lengthH:-1:1
                itemHandle = List.Add;
                % store the first item handle
                if isempty(latestHistoryItem)
                    latestHistoryItem = itemHandle;
                end
                set( itemHandle, 'text', H{ind}.Comment );
                set( itemHandle, 'SubItems', 1, H{ind}.Time );
            end
            % make sure the latest Item is Selected, and Visible
            latestHistoryItem.Selected = 1;
            EnsureVisible(latestHistoryItem);
        end
        d = pHistoryManager( pFN, d, 'refreshdetails' );

    case 'refreshdetails'
        if ~isempty(Selected)
            index = i_ListIndex2HistoryIndex( Selected, lengthH );
            set(d.Handles.Details,'string',H{index}.Details,...
                'enable','on',...
                'backgroundcolor',sc.WINDOW_BG);
        else
            set(d.Handles.Details,'string','',...
                'enable','off',...
                'backgroundcolor',sc.CTRL_BG);
        end

    case 'detailsedit'
        if ~isempty( Selected )
            index = i_ListIndex2HistoryIndex( Selected, lengthH );
            H{index}.Details = get(d.Handles.Details,'string');
            pF.info = pF.set('history',H);
        end
        
    case 'rename'
        index = i_ListIndex2HistoryIndex( Selected, lengthH );
        H{index}.Comment = varargin{1};
        pF.info = pF.set('history',H);
        
    case 'add'
        comment = 'New';
        details = '';
        pF.info = pF.addhistoryitem(comment, details);
        d = pHistoryManager( pFN, d, 'drawlist' );

    case 'remove'
        if isempty(Selected)
            d = pMessage(d,'Select one or more history record log numbers to remove');
            return
        end
        index = i_ListIndex2HistoryIndex( Selected, lengthH );
        H(index) = [];
        pF.info = pF.set('History',H);
        % now refresh the list
        d = pHistoryManager( pFN, d, 'drawlist' );
        i_setSelectedItem( d, Selected - 1 );

end


% -------------------------------------------
function  i_setSelectedItem( d, index )
% -------------------------------------------
if index>1
    List = d.Handles.History.ListItems;
    selectedIndex = i_getSelectedItem( d );
    set( List.Item(selectedIndex), 'Selected', false );
    set( List.Item(index), 'Selected', true );
end

% -------------------------------------------
function Selected = i_getSelectedItem( d )
% -------------------------------------------

% Refresh details display
if ~isempty(d.Handles.History.SelectedItem)
    Selected = double(d.Handles.History.SelectedItemIndex);
else
    Selected = [];
end

% -------------------------------------------
function historyIndex = i_ListIndex2HistoryIndex( listindex, lengthH )
% -------------------------------------------
indexmap = lengthH:-1:1;
historyIndex = indexmap( listindex );
