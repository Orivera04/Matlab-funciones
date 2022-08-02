function [otf, OK] = guiSetUp(otf, pPROJ, pOPTIM)
%GUISETUP Set up the required tables for filling via a GUI
%  [NEWOTF, OK] = SETUP(OTFIN, pPROJ, pOPTIM, [hParent])  where OTFIN
%  is a cgoptimtablefiller object, pPROJ is a pointer to a cage project and
%  pOPTIM is a pointer to the current optimization. hParent is an optional
%  handle to a parent figure.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/04/04 03:26:14 $

% Keep a copy of the old table filling object in case the user decides to
% cancel from the wizard
oldotf = otf;

if nargin<5
    hParent = [];
end
[OK, out] = xregwizard(hParent, 'Table Filling from Optimization Results Wizard', ...
    {@i_createCardOne, pPROJ, pOPTIM, otf});
if OK
    [data, colheads, pfillfacs] = getsolution(pOPTIM.info, 1);
    soltypecell = {'solution', 'pareto', 'weightedpareto'};
    otf.tables = out.tables(out.matching(:, 1));
    otf.fillfactors = pfillfacs(out.matching(:, 2));
    otf.solutiontype = soltypecell(out.matching(:, 3));
    otf.solutionindex = (out.matching(:, 4))';
else
    otf = oldotf;
end

%------------------------------------------------------------------------
% CARD ONE FUNCTIONS BELOW
%------------------------------------------------------------------------
function [layout, localData] = i_createCardOne( pPROJ,pOPTIM, otf, fh, iFace, localData )
% GUI Layout for card one: Choose tables to be filled

if isa(fh, 'xregcontainer')
    layout = fh;
    layoutUD = get(layout, 'userdata');
else
    % Set the wizard size to be more appropriate
    feval(iFace.setWizardSize, [650 400]);

    [llistlyt, layoutUD.hllist] = i_listlayout(fh, 'Available CAGE tables:');


    pushselect = xregGui.iconuicontrol('parent',  fh, ...
        'style', 'pushbutton', ...
        'visible', 'off', ...
        'TransparentColor', [0 255 0], ...
        'ImageFile', cgrespath('rightarrow.bmp'), ...
        'tooltipstring', 'Add table to fill', ...
        'callback', {@i_cbpushselect, iFace});

    pushdeselect = xregGui.iconuicontrol('parent',  fh, ...
        'style', 'pushbutton', ...
        'visible', 'off', ...
        'TransparentColor', [0 255 0], ...
        'ImageFile', cgrespath('leftarrow.bmp'), ...
        'tooltipstring', 'Remove table to fill', ...
        'callback', {@i_cbpushdeselect, iFace});

    btnlyt = xreggridbaglayout(fh, ...
        'dimension', [5 1], ...
        'rowsizes', [-1 25 5 25 -1], ...
        'gapy', 5, ...
        'elements', {[], pushselect, [], pushdeselect, []});

    [rlistlyt, globalUD.hrlist] = i_listlayout(fh, 'CAGE tables to be filled:');

    layout = xreggridbaglayout(fh, ...
        'dimension', [1 5], ...
        'colsizes', [-1 10 25 10 -1], ...
        'elements', {llistlyt, [], btnlyt, [], rlistlyt}, ...
        'border', [7 0 7 10]);
    infostr = {'Select the CAGE tables that you wish to fill from the optimization results'};
    layout = i_maketitlearea(fh, 'Table Selection', infostr, layout);

    % Store some useful info
    globalUD.Project = pPROJ;
    globalUD.Optim = pOPTIM;
    %    globalUD.Oppoint = pData;
    globalUD.tabfiller = otf;
    layoutUD.nextFcn = @i_cardOneNext;
    layoutUD.cancelFcn = @i_cardCancel;
    [pTabs, cgtabnames] = i_NoEmptyNoNormTabs(pPROJ);

    % Array of possible table names. Just include those tables where ALL
    % axis pointers are in the factor list of the optimization output data
    pTabs = i_EnsureTabAxesInOptim(pTabs, pOPTIM);
    if ~isempty(pTabs)
        cgtabnames = pveceval(pTabs, 'getname');
    else
        cgtabnames = [];
    end
    layoutUD.posstabsnames = cgtabnames;

    % Are we editing an existing valid set-up, or creating a new table fill
    % set-up?
    if isempty(otf)
        % put the cage table names in the lhs listbox
        layoutUD.hllist.Items = pTabs;
        layoutUD.hllist.SelectedItems = pTabs(1);
        globalUD.lhtabind = 1:length(pTabs);
        globalUD.rhtabind = [];
    else
        % determine which tables have been set up to be filled.
        pSetUpTabs = otf.tables;
        selinds = findptrs(pSetUpTabs, pTabs);
        notselinds = setdiff(1:length(pTabs), selinds);
        globalUD.lhtabind = notselinds;
        globalUD.rhtabind = selinds;
        layoutUD.hllist.Items = pTabs(notselinds);
        globalUD.hrlist.Items = pTabs(selinds);
        if ~isempty(notselinds)
            layoutUD.hllist.SelectedItems = pTabs(notselinds(1));
        end
        if ~isempty(selinds)
            globalUD.hrlist.SelectedItems = pTabs(selinds(1));
        end
    end
    globalUD.posstabs = pTabs;
    feval( iFace.setUserData,  globalUD );
end

layoutUD = i_cardOneUpdate( layoutUD, iFace );
feval( iFace.setFinishButton, 'off' );
globalUD = feval(iFace.getUserData);
en = i_enableCardTwo(globalUD.rhtabind);
feval( iFace.setNextButton,   en );
set( layout, 'userdata', layoutUD );

%--------------------------------------------------------------------------
function layoutUD = i_cardOneUpdate(layoutUD, iFace)
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
function [layout, listbox] = i_listlayout(fh, titstr)
%--------------------------------------------------------------------------

listtitle = xreguicontrol('parent', fh, ...
    'visible', 'off', ...
    'style', 'text', ...
    'string', titstr, ...
    'enable', 'inactive', ...
    'horizontalalignment', 'left');

listbox = cgtools.exprList('parent', fh, ...
    'visible', 'off', ...
    'displaytypecolumn', false, ...
    'itemheadertext', 'Table');

layout = xreggridbaglayout(fh, ...
    'dimension', [4 1], ...
    'rowsizes', [15 5 -1 5], ...
    'elements', {listtitle,[], listbox, []});

%------------------------------------------------------------------------
function i_cbpushselect(src, evt, iFace)
%------------------------------------------------------------------------

% Push the selected table into the 'selected' list

UD = feval(iFace.getCardUserdata);
GD = feval(iFace.getUserData);
[UD.hllist, GD.hrlist, GD.lhtabind, GD.rhtabind, UD.posstabsnames] = ...
    i_selectpgone(UD.hllist, GD.hrlist, GD.lhtabind, GD.rhtabind, GD.posstabs);
feval(iFace.setCardUserdata, UD);
feval(iFace.setUserData, GD);
en = i_enableCardTwo(GD.rhtabind);
feval( iFace.setNextButton, en);


%------------------------------------------------------------------------
function i_cbpushdeselect(src, evt, iFace)
%------------------------------------------------------------------------

% Retrieve the selected table from the 'selected' list

UD = feval(iFace.getCardUserdata);
GD = feval(iFace.getUserData);
[GD.hrlist, UD.hllist, GD.rhtabind, GD.lhtabind, UD.posstabsnames] = ...
    i_selectpgone(GD.hrlist, UD.hllist, GD.rhtabind, GD.lhtabind, GD.posstabs);
feval(iFace.setCardUserdata,UD);
feval(iFace.setUserData, GD);
en = i_enableCardTwo(GD.rhtabind);
feval( iFace.setNextButton, en);

%------------------------------------------------------------------------
function [hSource, hSink, indSource, indSink, allTabs] = ...
    i_selectpgone(hSource, hSink, indSource, indSink, allTabs)
%------------------------------------------------------------------------

% Subfunction handling the selection between lists
% Have a source list ----> sink list

lhItems = hSource.Items;
if ~isempty(lhItems)
    % Set indices
    NLHS = length(lhItems);
    lhval = hSource.SelectedIndex;
    newlhind = setdiff(1:NLHS, lhval);
    newtabind = indSource(lhval);
    indSink = [indSink newtabind];
    indSink = sort(indSink);
    indSource = indSource(newlhind);
    % Set strings
    newlhtabs = allTabs(indSource);
    newrhtabs = allTabs(indSink);
    hSource.Items = newlhtabs;
    hSink.Items = newrhtabs;
    % Set selected item in source list
    if lhval > length(newlhind)
        if length(indSource) > 0
            hSource.SelectedItems = allTabs(indSource(1));
        end
    else
        hSource.SelectedItems = allTabs(indSource(lhval));
    end
    % Set selected item in sink list
    hSink.SelectedItems = allTabs(newtabind);
else
    % Cannot select any more CAGE tables
end

%--------------------------------------------------------------------------
function en = i_enableCardTwo(rhind)
%--------------------------------------------------------------------------

if ~isempty(rhind)
    en = 'on';
else
    en = 'off';
end

%------------------------------------------------------------------------
function [nextCardID, localData] = i_cardOneNext( layoutUD, iFace )
%------------------------------------------------------------------------

nextCardID = @i_createCardTwo;
localData = [];

%------------------------------------------------------------------------
% CARD TWO FUNCTIONS BELOW
%------------------------------------------------------------------------
function [layout, localData] = i_createCardTwo(fh, iFace, localData )

if isa(fh, 'xregcontainer')
    layout = fh;
    layoutUD = get(layout, 'userdata');
else
    % Draw the ListView control
    layoutUD.List = actxcontainer(...
        actxcontrol('mwmbccontrols.listviewctrl',...
        [0 0 1 1],fh));
    set(layoutUD.List,'hideselection',0);
    set(layoutUD.List,'FullRowSelect',1);
    set(layoutUD.List,'labeledit',1);

    % Listen for user selection of the table to fill. The callback ensures
    % that the solution type and index in the list reflects that in the
    % solntypeselector
    layoutUD.listlisten = handle.listener(layoutUD.List, 'ItemClick', {@i_selecttable, iFace});

    % Allow icon display in the list
    layoutUD.imgmgr=xregGui.ILmanager;
    layoutUD.imgmgr.IL.MaskColor=uint32(255*256*256 + 255);   % Magenta mask
    layoutUD.imgmgr.ResourceLocation=cgrespath;
    bmp2ind(layoutUD.imgmgr,'cgblanknode.bmp');
    layoutUD.List.InsertSmallIcons(layoutUD.imgmgr.IL);

    % make the columns for the listview
    Cols = layoutUD.List.ColumnHeaders;
    Str = {'CAGE Table','Output Column', 'Solution Type', 'Op.Pt/Solution'};
    cwid = [95 85 85 85];
    for i = 1:4
        colItem = invoke(Cols,'Add');
        set(colItem,'text',Str{i},'width',cwid(i));
    end
    set(layoutUD.List,'View',3);

    % Make a title for this ListView
    t= uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'horizontalalignment','left',...
        'String','Tables to be filled:');
    layoutUD.selbutton = xregGui.iconuicontrol('parent',  fh, ...
        'style', 'pushbutton', ...
        'visible', 'off', ...
        'TransparentColor', [0 255 0], ...
        'ImageFile', cgrespath('leftarrow.bmp'), ...
        'tooltipstring', 'Select optimization output column', ...
        'callback', {@i_selectObj,iFace});

    t2= uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'horizontalalignment','left',...
        'String','Optimization results:');

    layoutUD.namelist = cgtools.exprList('parent', fh, ...
        'visible', 'off', ...
        'displaytypecolumn', false, ...
        'itemheadertext', 'Optimization Results');

    globalUD = feval(iFace.getUserData);
    layoutUD.solntypesel = cgoptimgui.solntypeselector(globalUD.Optim, 'parent', fh);
    layoutUD.stypelist = handle.listener(layoutUD.solntypesel, ...
        'TypeChanged', {@i_setNewSoln, iFace});
    txtsolsel= uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'horizontalalignment','left',...
        'String','Output data to fill tables:');

    layout = xreggridbaglayout('parent', fh, ...
        'dimension', [9 3], ...
        'gapx', 10, ...
        'border', [7 0 7 10], ...
        'rowsizes', [15 5 -1 30 -1 5 15 5 100], ...
        'colsizes', [-1 30 -1], ...
        'colratios', [2 0 1], ...
        'mergeblock', {[3 5], [1 1]}, ...
        'mergeblock', {[3 5], [3 3]}, ...
        'elements', {t, [], layoutUD.List, [], [], [], txtsolsel, [],layoutUD.solntypesel, ...
        [], [], [], layoutUD.selbutton, [], [], [], [],[], ...
        t2, [], layoutUD.namelist, []});
    infostr = 'Choose the optimization results that you wish to fill each table with';
    layout = i_maketitlearea(fh, 'Optimal Result Selection', infostr, layout);
    layoutUD.matching = [];
    layoutUD.finishFcn = @i_Finish;

    % On first call to this page, transfer the table filling set-up
    % information from a previous set-up (if this exists)
    %    pData = globalUD.Oppoint;
    pOPTIM = globalUD.Optim;
    otf = globalUD.tabfiller;

    if ~isempty(otf)
        % Get set up info from data set
        pSetUpTabs = otf.tables;
        pLinks = otf.fillfactors;

        % Get all possible tables that could be filled
        [pTabs, cgtabnames] = i_NoEmptyNoNormTabs(globalUD.Project);
        pTabs = i_EnsureTabAxesInOptim(pTabs, pOPTIM);

        % Find each table that could possibly be filled in the list of
        % tables that have already been set up
        inds = findptrs(pTabs, pSetUpTabs);

        % Indices of tables that have been matched (col 1 in
        % layoutUD.matching)
        tabsmatched = find(inds);
        tabsmatched = tabsmatched(:);

        % Indices of matched tables (into matched table list) in order they
        % appear in the newmatching list
        indsord = inds(tabsmatched);

        % Get index of output factor to fill table
        [notneeded, notneeded2, pOut] = getsolution(pOPTIM.info, 1);
        indoutput = findptrs(pLinks, pOut);
        indoutput = indoutput(:);

        % Get solution type for each table
        soltypevec = {'solution', 'pareto', 'weightedpareto'};
        solntype = zeros(length(pSetUpTabs), 1);
        for i =1:length(otf.solutiontype)
            solntype(i) = strmatch(otf.solutiontype{i}, soltypevec);
        end

        % Get solution number for each table
        soln = (otf.solutionindex)';

        % Form layoutUD.matching
        layoutUD.matching =[tabsmatched,  indoutput(indsord), solntype(indsord), soln(indsord)];

    end
end

layoutUD = i_cardTwoUpdate( layoutUD, iFace );
en = i_enableFinish(layoutUD);
feval( iFace.setFinishButton, en );
feval( iFace.setNextButton,   'off' );
set( layout, 'userdata', layoutUD );
% Ensure that all lists are consistent
i_makelistsconsistent(layoutUD);

%--------------------------------------------------------------------------
function layoutUD = i_cardTwoUpdate(layoutUD, iFace)
%--------------------------------------------------------------------------

% fills the card with information
ListItems= layoutUD.List.ListItems;
invoke(ListItems,'Clear');

% fill the left-hand list box, first column
globalUD = feval(iFace.getUserData);
tabSelected = globalUD.hrlist.Items;
tabLabels = pveceval(tabSelected, 'getname');
for i =1: length(tabLabels)
    hand = invoke(ListItems,'add');
    set(hand,'text', tabLabels{i});
    icon = iconfile(tabSelected(i).info);
    set(hand, 'smallicon', bmp2ind(layoutUD.imgmgr,icon));
end

% Set up the matching matrix
if isempty(layoutUD.matching)
    layoutUD.matching = zeros(layoutUD.List.ListItems.Count, 4);
    layoutUD.matching(:, 1)= globalUD.rhtabind;
else
    layoutUD = i_updateMatch(layoutUD, globalUD);
end

% fill the right hand list box %
globalUD = feval(iFace.getUserData);
pPROJ = globalUD.Project;
pOPTIM = globalUD.Optim;
[notneeded, AllNames, pSolutions] = getsolution(pOPTIM.info, 1);
layoutUD.namelist.Items = pSolutions;

% Match if the user has already matched this table %
for i = 1:get(ListItems, 'count')
    thisitem = get(ListItems, 'item', i);
    if layoutUD.matching(i, 2) > 0
        matchind = layoutUD.matching(i, 2);
        curName = AllNames{matchind};
        thisitem.ListSubItems.Add(1, '', curName, ...
            layoutUD.imgmgr.bmp2ind(iconfile(pSolutions(matchind).info)));
    end

    if layoutUD.matching(i, 3) > 0 ...
            && i_checkSolution(pOPTIM, layoutUD.matching(i, 3), layoutUD.matching(i, 4));
        switch layoutUD.matching(i, 3)
            case 1
                typestr = 'solution';
            case 2
                typestr = 'pareto';
            case 3
                typestr = 'weightedpareto';
        end
        numstr = num2str(layoutUD.matching(i, 4));
        set(thisitem,'subitems',2,typestr);
        set(thisitem,'subitems',3,numstr);
    end

end

%--------------------------------------------------------------------------
function ok = i_checkSolution(pOPTIM, soltype, solindex)
%--------------------------------------------------------------------------

try
    switch soltype
        case 1
            data = getsolution(pOPTIM.info, solindex);
        case 2
            data = getparetosolution(pOPTIM.info, solindex);
        case 3
            data = getweightedsolution(pOPTIM.info);
    end
    ok = true;
catch
    ok = false;
end


%--------------------------------------------------------------------------
function layoutUD = i_updateMatch(layoutUD, globalUD)
%--------------------------------------------------------------------------

newmatching = zeros(length(globalUD.rhtabind), 4);
for i = 1:length(globalUD.rhtabind)
    ind = find(layoutUD.matching(:, 1) == globalUD.rhtabind(i));
    newmatching(i, 1) = globalUD.rhtabind(i);
    if ~isempty(ind)
        newmatching(i, 2:4) = layoutUD.matching(ind, 2:4);
    end
end
layoutUD.matching = newmatching;

%--------------------------------------------------------------------------
function i_selectObj(src, evt, iFace)
%--------------------------------------------------------------------------

% objective function selection
layoutUD = feval(iFace.getCardUserdata);

% get handles
target=layoutUD.List.selecteditem;
curlst=layoutUD.namelist;

% get the model name to change
pSel = curlst.SelectedItem;
curName = getname(pSel.info);

% Set the target name to be curname
thissubitems = target.ListSubItems;
if thissubitems.count > 0
    thissubitems.Remove(1);
end
thissubitems.Add(1, '', curName, ...
    layoutUD.imgmgr.bmp2ind(iconfile(pSel.info)));

% Set the target solution type and index if this has not already been set
if thissubitems.count < 2
    i_setNewSoln([], [], iFace);
    % Get the card user data again, as this is set by i_setNewSoln
    layoutUD = feval(iFace.getCardUserdata);
end

% record the users choice
layoutUD.matching(layoutUD.List.selecteditemindex, 2) = curlst.SelectedIndex;
feval(iFace.setCardUserdata, layoutUD);

en = i_enableFinish(layoutUD);
feval(iFace.setFinishButton, en);

%--------------------------------------------------------------------------
function i_selecttable(src, evt, iFace)
%--------------------------------------------------------------------------

% This callback is fired when a user selects a table in the main list. This
% callback ensures that the information in the Optimization output column
% list and the solution type/index selector is consistent with the main
% list.

% Get layout user data
layoutUD = feval(iFace.getCardUserdata);

% Make the lists consistent
i_makelistsconsistent(layoutUD);

%--------------------------------------------------------------------------
function i_makelistsconsistent(layoutUD)
%--------------------------------------------------------------------------

% Get the component corresponding to the current table
target=layoutUD.List.selecteditem;
thissubitems = target.ListSubItems;

% Callback should not update lists if the user has made no selection
if thissubitems.Count < 1
    return
end

% Update the selected item in the output results list
layoutUD.namelist.SelectedIndex = layoutUD.matching(layoutUD.List.selecteditemindex, 2);

% Update the solution type/index
infstr.type = get(target,'subitems',2);
infstr.index = str2num(get(target,'subitems',3));
% Temporarily disable the listener on the solution type selector, as we are
% not setting a new sol type/index here.
set(layoutUD.stypelist, 'enable', 'off');
layoutUD.solntypesel.setInfo(infstr);
set(layoutUD.stypelist, 'enable', 'on');

%--------------------------------------------------------------------------
function en = i_enableFinish(layoutUD)
%--------------------------------------------------------------------------

% Return (0) or 1 if finish button can be (not) enabled
en = 'on';
ListItems= layoutUD.List.ListItems;
for i = 1:get(ListItems, 'count')
    thisitem = get(ListItems, 'item', i);
    thisub1 = get(thisitem, 'subitems', 1);
    thisub2 = get(thisitem, 'subitems', 2);
    thisub3 = get(thisitem, 'subitems', 3);
    if isempty(thisub1) || isempty(thisub2) || isempty(thisub3)
        en = 'off';
        break;
    end
end

%--------------------------------------------------------------------------
% FINISH FUNCTIONS
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
function i_Finish(layoutUD, iFace)
%--------------------------------------------------------------------------

globalUD = feval(iFace.getUserData);
out.matching = layoutUD.matching;
out.tables = globalUD.posstabs;
feval(iFace.setOutputData, out);

%--------------------------------------------------------------------------
% UTILITY FUNCTIONS
%--------------------------------------------------------------------------
function lyt = i_maketitlearea(fh, sTitle, sInfo, hCenter)
% Wrap a layout handle with a pretty titled area containing more
% information
SC = xregGui.SystemColorsDbl;
infopatch = xregGui.oblong('parent', fh, ...
    'color', SC.WINDOW_BG, ...
    'visible', 'off');
infotextTitle = uicontrol('parent', fh, ...
    'style', 'text', ...
    'hittest', 'off', ...
    'backgroundcolor', SC.WINDOW_BG, ...
    'horizontalalignment', 'left', ...
    'string', sTitle, ...
    'visible', 'off', ...
    'fontweight', 'bold');
infotextInfo = uicontrol('parent', fh, ...
    'style', 'text', ...
    'hittest', 'off', ...
    'backgroundcolor', SC.WINDOW_BG, ...
    'horizontalalignment', 'left', ...
    'string', sInfo, ...
    'visible', 'off');
infoline = xregGui.dividerline('parent', fh, ...
    'visible', 'off');
sublyt = xreglayerlayout(fh, ...
    'border', [10 0 0 0],...
    'elements', {infotextInfo});
lyt = xreggridbaglayout(fh, ...
    'dimension', [6 3], ...
    'rowsizes', [5 15 30 5 2 -1], ...
    'colsizes', [10  -1 10], ...
    'mergeblock', {[1 4], [1 3]}, ....
    'mergeblock', {[5 5], [1 3]}, ...
    'mergeblock', {[6 6], [1 3]}, ...
    'elements', {infopatch, [],[],[],infoline, hCenter, [],infotextTitle, sublyt});

function i_cardCancel(layoutUD, iface)

%--------------------------------------------------------------------------
function i_setNewSoln(src, evt, iFace)
%--------------------------------------------------------------------------

% objective function selection
layoutUD = feval(iFace.getCardUserdata);

% get handles
target=layoutUD.List.selecteditem;

% Get the new solution type and index from the solntypeselector
infstr = layoutUD.solntypesel.getInfo;

% set the solution typeand oppt/soln index
set(target,'subitems',2,infstr.type);
set(target,'subitems',3,infstr.index);

% record the users choice
switch infstr.type
    case 'solution'
        Ind = 1;
    case 'pareto'
        Ind = 2;
    case 'weightedpareto'
        Ind = 3;
end
layoutUD.matching(layoutUD.List.selecteditemindex, 3) = Ind;
layoutUD.matching(layoutUD.List.selecteditemindex, 4) = infstr.index;
feval(iFace.setCardUserdata, layoutUD);

en = i_enableFinish(layoutUD);
feval(iFace.setFinishButton, en);

%--------------------------------------------------------------------------
function pFiltTabs = i_EnsureTabAxesInOptim(pTabs, pOptim)
%--------------------------------------------------------------------------

% Get the pointers (PTRS) to the output data that can be used to fill the tables.
% For a table to be eligible to be filled, the axis pointers of the table
% must be in PTRS.
[notneeded, notneeded2, pOut] = getsolution(pOptim.info, 1);

filter = true(1, length(pTabs));
for i = 1:length(pTabs)
    % Get table axes
    axes = pTabs(i).get('axesptrs');

    % Are all pointers in PTRS ?
    ind = findptrs(axes, pOut);
    if any(~ind)
        filter(i) = false;
    end
end
pFiltTabs = pTabs(filter);

%--------------------------------------------------------------------------
function [pTabs, cgtabnames] = i_NoEmptyNoNormTabs(pRoot)
%--------------------------------------------------------------------------
% I_NOEMPTYNONORMTABS Produce a filtered list of CAGE tables
%   PTABS = CGNOEMPTYNONORMTABS(PROOT) returns a list of pointers to CAGE
%   tables in the CAGE project pointed to by PROOT. The returned list will
%   not contain any normalizers or uninitialized tables.
%

pTabs = pRoot.gettables;
EmptyTabs = pveceval(pTabs, @isempty);
EmptyTabs = [EmptyTabs{:}];
pTabs = pTabs(~EmptyTabs);
cgtabnames = pveceval(pTabs, @getname);
