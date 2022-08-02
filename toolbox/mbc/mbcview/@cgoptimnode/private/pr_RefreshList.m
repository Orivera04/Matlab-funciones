function pr_RefreshList(lh, Opt, IL)
%PR_REFRESHLIST 
%
%  Private method to refresh any of the list controls in cgoptimnode

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.3 $    $Date: 2004/04/04 03:33:50 $

% INPUTS    :   lh          -   Handle to the ActiveX list
%               Opt         -   cgoptimnode
%               IL          -   Image List manager

% OUTPUTS   :
%

% Note that this method should be called
%   1. When the optim node is viewed
%   2. After any callback of the list is performed

pO = getdata(Opt);
% Get the members of the list - determined by the labels from the optim object
listname = get(lh, 'UserData');


switch listname
case 'Objective'
    listmem = get(pO.info, 'objectivelabels');
case 'Operating Point Set'
    listmem = get(pO.info, 'oppointlabels');
case 'Constraint'
    listmem = get(pO.info, 'constraintlabels');
end


% Get the activeX handle to the collection of items in this list
hLitems = lh.listitems;
% Clear to the list
if lh.ListItems.Count>0
    currindex = get(lh, 'selecteditemindex');
else
    currindex = [];
end
invoke(hLitems, 'clear');

% Make initial listing sorted by internal object order.
set(lh, 'sorted', false);

if isempty(listmem)
    % There's nothing in the list - tell the user
    newhLitem = invoke(hLitems,'add');
    str = ['There are no ',lower(listname),'s in this optimization'];
    hCols = lh.ColumnHeaders;
    set(get(hCols, 'Item', 2), 'width', 230);
    set(newhLitem,'SubItems',1,str);  
    set(lh.SelectedItem, 'Selected', 0);
else
    vals = listvals(Opt, listname);
    nExtra = size(vals,2);
    iconbmp = pr_Iconfile(listname);
    ic=bmp2ind(IL,iconbmp);
    for n=1:length(listmem)
        % add node and set values
        newhLitem = hLitems.Add(n, pr_Genkey(listname, n), listmem{n});
        newhLitem.Tag = listname;
        newhLitem.SmallIcon = ic;
        for m=1:nExtra
            set(newhLitem,'SubItems',m,vals{n,m});  
        end
    end
    hLitems = lh.listitems;
    if (~isempty(currindex) && ~isequal(currindex,-1) && currindex<=length(listmem))
        set(get(hLitems, 'item', currindex), 'selected', 1);    
    end
end
