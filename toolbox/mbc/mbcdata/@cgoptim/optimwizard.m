function [objout, OK] = optimwizard(objin, pPROJ, hParent)
%OPTIMWIZARD Wizard for creating a new optimization object
%
%  [NEWOPT, OK] = OPTIMWIZARD(OPT, pPROJ, [hParent])  where OPT is a
%  cgoptim object, pPROJ is a pointer to a cage project and hParent is an
%  optional handle to a parent figure.
%
%  See also XREGWIZARD.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.12.8.5 $    $Date: 2004/04/12 23:34:29 $

if nargin<3
    hParent = [];
end
[OK, out] = xregwizard(hParent, 'Optimization Wizard', {@i_createCardOne, pPROJ});
if OK
    objout = out.optim;
else
    objout = objin;
end



%------------------------------------------------------------------------
% CARD ONE FUNCTIONS BELOW
%------------------------------------------------------------------------
function o__________CARD_ONE_Select_an_algorithm
%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [layout, localData] = i_createCardOne( pPROJ, fh, iFace, localData )
% GUI Layout for card one: Select an algorithm

if isa(fh, 'xregcontainer')
    layout = fh;
    layoutUD = get(layout, 'userdata');
else
    % Set the wizard size to be more appropriate
    feval(iFace.setWizardSize, [600 300]);
    
    SC = xregGui.SystemColorsDbl;
    
    builtin = initfrommbc(cgoptimfuncs);
    userfuncs = cgoptimfuncs;
    
    optimlist = [makeoptim(builtin), makeoptim(userfuncs)];
    optimdata = struct( 'list', {optimlist}, 'index', -1 );
    layoutUD.optimdata = xregGui.RunTimePointer( optimdata );
    layoutUD.optimdata.LinkToObject(fh);
    
    listtitle = xreguicontrol('parent', fh, ...
        'visible', 'off', ...
        'style', 'text', ...
        'string', 'Available optimization algorithms:', ...
        'enable', 'inactive', ...
        'horizontalalignment', 'left');
    % Draw the ListView control
    listbox = actxcontainer(...
        xregGui.listview(...
        [0 0 1 1],fh));
    set(listbox,'hideselection',0);
    set(listbox,'FullRowSelect',1);
    set(listbox,'labeledit',1);
    % make the columns for the listview
    Cols= listbox.ColumnHeaders;
    Str={'Name','Free Variables','Objectives','Constraints','Operating Point Sets'};
    cwid= [120 85 80 80 115];
    for n=1:5
        colItem= invoke(Cols,'Add');
        set(colItem,'text',Str{n});
        set(colItem,'width',cwid(n));
    end
    set(listbox,'View',3);
    
    for n = 1:length(optimlist)            
        hand =invoke(listbox.ListItems,'add');
        set(hand,'text', getname(optimlist{n}));
        set(hand,'SubItems',1,get(optimlist{n},'canaddvaluesstring'));
        set(hand,'SubItems',2,get(optimlist{n},'canaddobjectiveFuncsstring'));
        set(hand,'SubItems',3,get(optimlist{n},'canaddconstraintsstring'));
        set(hand,'SubItems',4,get(optimlist{n},'canaddoppointsstring'));
    end
    
    layoutUD.oppointnames = []; 
    layoutUD.oppointptrs =  [];
    layoutUD.listbox = listbox;
    layoutUD.nextFcn = @i_cardOneNext;
    layoutUD.cancelFcn = @i_cardCancel;
    
    layout = xreggridbaglayout(fh, ...
        'dimension', [2 1], ...
        'rowsizes', [15 -1], ...
        'gapy', 5, ...
        'elements', {listtitle, listbox}, ...
        'border', [7 0 7 10]);
    infostr = {'Select from the list the algorithm that you want the new optimization to use.'};
    layout = i_maketitlearea(fh, 'Algorithm Selection', infostr, layout);
    
    globalUD.Project = pPROJ;
    feval( iFace.setUserData,  globalUD );
end

feval( iFace.setFinishButton, 'off' );
feval( iFace.setNextButton,   'on' );
set( layout, 'userdata', layoutUD );
return

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [nextCardID, localData] = i_cardOneNext( layoutUD, iFace )

optimdata = layoutUD.optimdata;

% Get the selected item from the listview
selected = layoutUD.listbox.selecteditem;
index = double( selected.index );

% set the index of the chosen optimization object in the user data for Card One
optimdata.info.index = index;
feval( iFace.setCardUserdata, layoutUD );

% Set the localData
localData = optimdata;

% Check to see if we need to go to card two
obj = optimdata.info.list{index};
canAddValues      = get( obj, 'canaddvalues' );    
canAddObjFuncs    = get( obj, 'canaddobjectiveFuncs' );
canAddConstraints = get( obj, 'canaddconstraints' );
canAddOppoints    = get( obj, 'canaddoppoints' );
if canAddValues || canAddObjFuncs || canAddConstraints || canAddOppoints
    nextCardID = @i_createCardTwo;
else
    % we can skip card two
    nextCardID = @i_createCardThree;
end

return


%------------------------------------------------------------------------
% CARD TWO FUNCTIONS BELOW
%------------------------------------------------------------------------
function o__________CARD_TWO_Number_of_things
%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function layout = i_createCardTwo( fh, iFace, localData )
% GUI Layout for card two: Number of free variables, objectives, constraints 
% and OpPoint sets

% Have we been called to create the layout or simply update?
if isa( fh, 'xregcontainer' )
    layout = fh;
    layoutUD = get( layout, 'userdata' );
    
else    
    clickedit = xregGui.clickedit('parent', fh,...
        'rule','int', ...
        'min', 1, ...
        'max', realmax, ...
        'visible', 'off');
    clickedit2 = xregGui.clickedit('parent', fh,...
        'rule','int', ...
        'min', 0, ...
        'max', realmax, ...
        'visible', 'off');
    clickedit3 = xregGui.clickedit('parent', fh,...
        'rule','int', ...
        'min', 0, ...
        'max', realmax, ...
        'visible', 'off');
    clickedit4 = xregGui.clickedit('parent', fh,...
        'rule','int', ...
        'min', 0, ...
        'max', realmax, ...
        'visible', 'off');
    
    numfree = xregGui.labelcontrol('parent', fh,...
        'LabelSizeMode','absolute',...
        'LabelSize',180,...
        'ControlSize',60,...
        'string', 'Number of free variables:',...
        'control', clickedit,...
        'visible', 'off', ...
        'GrayDisable', 'off');
    numobj = xregGui.labelcontrol('parent', fh,...
        'LabelSizeMode','absolute',...
        'LabelSize',180,...
        'ControlSize',60,...
        'string', 'Number of objectives:',...
        'control', clickedit2,...
        'visible', 'off', ...
        'GrayDisable', 'off');
    numcon = xregGui.labelcontrol('parent', fh,...
        'LabelSizeMode','absolute',...
        'LabelSize',180,...
        'ControlSize',60,...
        'string', 'Number of constraints:',...
        'control', clickedit3,...
        'visible', 'off', ...
        'GrayDisable', 'off');
    numops = xregGui.labelcontrol('parent', fh,...
        'LabelSizeMode','absolute',...
        'LabelSize',180,...
        'ControlSize',60,...
        'string', 'Number of operating point sets:',...
        'control', clickedit4,...
        'visible', 'off', ...
        'GrayDisable', 'off');
    
    layout = xreggridbaglayout(fh,...
        'dimension', [6 1],...
        'rowsizes',[-1 20 20 20 20 -1],...
        'rowratios', [1 0 0 0 0 2], ...
        'border', [30 0 0 0],...
        'gapy', 7,...
        'elements', {[], numfree, numobj,numcon,numops});
    infostr = ['Algorithms may be able to use a variable number of items.', ...
            '  Select the number of each item that you want to use in this optimization.'];
    layout = i_maketitlearea(fh, 'Algorithm Options', infostr, layout);
    
    layoutUD.numfree  = numfree;
    layoutUD.numobj = numobj;
    layoutUD.numcon = numcon;
    layoutUD.numops = numops;
    
    layoutUD.nextFcn = @i_cardTwoNext;
    layoutUD.cancelFcn = @i_cardCancel;
end

if nargin > 2,
    layoutUD.optimdata = localData;
end

layoutUD = i_cardTwoUpdate( layoutUD, iFace );
set( layout, 'UserData', layoutUD );
return

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function layoutUD = i_cardTwoUpdate( layoutUD, iFace )
% Fills card two with information

SC = xregGui.SystemColorsDbl;
% Get the chosen optimization object
obj = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};

% Parameters for 'Number of free variables' question and edit
canaddvalues = get( obj, 'canaddvalues' );    
val = max( 1, length( get( obj, 'valueLabels' ) ) );
if canaddvalues
    obj = set( obj,'numvalues', val );
    enable = 'on';
    BackgroundColor = SC.WINDOW_BG;
else
    enable = 'inactive';
    BackgroundColor = SC.CTRL_BACK;
end
set( layoutUD.numfree,  'enable', enable);
set( layoutUD.numfree.Control,  'value', val, 'BackgroundColor', BackgroundColor );


% Parameters for 'Number of objectives' question and edit
canaddobjectiveFuncs = get( obj, 'canaddobjectiveFuncs' );
% only count the max/min objectives
count = 0;
objectives = get( obj, 'objectiveFuncs' );
for i = 1:length( objectives )
    if find( strcmp( objectives(i).get('minstr'), {'min', 'max'} ) ),
        count = count + 1;
    end
end
if canaddobjectiveFuncs == 1 % What test do we want to make?
    val = max( count, 1 );
    minval = 1;
elseif canaddobjectiveFuncs == 2
    val = max( count, 2 );
    minval = 2;
else
    val = count;
    minval = 1;
end
if canaddobjectiveFuncs
    obj = set( obj,'numobjectiveFuncs', val );
    enable = 'on';
    BackgroundColor = SC.WINDOW_BG;
else 
    enable = 'inactive';
    BackgroundColor = SC.CTRL_BACK;
end
set( layoutUD.numobj, 'enable', enable);
set( layoutUD.numobj.Control, 'min', minval, ...
    'value', val, ...
    'BackgroundColor', BackgroundColor);


% Parameters for 'Number of constraints' question and edit
canaddconstraints= get( obj, 'canaddconstraints' );
val = length( get( obj, 'modelconstraintLabels' ) );
if canaddconstraints
    enable = 'on';
    BackgroundColor = SC.WINDOW_BG;
else 
    enable = 'inactive';
    BackgroundColor = SC.CTRL_BACK;
end
set( layoutUD.numcon, 'enable', enable);
set( layoutUD.numcon.Control, 'value', val,  'BackgroundColor', BackgroundColor );


% Parameters for 'Number of operating point sets' question and edit
canaddoppoints= get( obj, 'canaddoppoints') ;
val = length( get( obj, 'oppointLabels' ) );
if canaddoppoints
    enable = 'on';
    BackgroundColor = SC.WINDOW_BG;
else 
    enable = 'inactive';
    BackgroundColor= SC.CTRL_BACK;
end
if canaddoppoints==2
    maxval = 1;
else
    maxval = realmax;
end
set( layoutUD.numops, 'enable', enable);
set( layoutUD.numops.Control, 'value', val,  'BackgroundColor', BackgroundColor, ...
    'max', maxval);

% Set the chosen optimization object
layoutUD.optimdata.info.list{layoutUD.optimdata.info.index} = obj;

% Always have to go to card three
feval( iFace.setFinishButton, 'Off' );
feval( iFace.setNextButton,   'On');

return


%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [nextCardID, localData] = i_cardTwoNext( layoutUD, iFace )

nfree = get( layoutUD.numfree.Control, 'value' );
nobj  = get( layoutUD.numobj.Control, 'value' );
ncon  = get( layoutUD.numcon.Control, 'value' );
nopp  = get( layoutUD.numops.Control, 'value' );

obj = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};

if get(obj,'canaddvalues')
    obj = set(obj,'numvalues', nfree);
end
if get(obj,'canaddobjectiveFuncs')
    obj = set(obj,'numobjectiveFuncs', nobj);
    
end

if get(obj,'canaddconstraints')

    currncon = get(obj, 'constraints');
    currncon = length(currncon);
    ncontoadd = ncon - currncon;
    obj = set(obj,'numconstraints', ncon);
   
    if ncontoadd > 0
        % Constraints are now added by the cgoptim class as empty ones
        % Set them to be CAGE model constraints in the wizard. 
        cons = get(obj, 'constraints');
        for n = currncon+1:ncon
            cons(n).info = set(cons(n).info, 'conobj', concgmodel(nfree));
        end
    end
end

if get(obj,'canaddoppoints')
    obj = set(obj,'numoppoints', nopp);
end
layoutUD.optimdata.info.list{layoutUD.optimdata.info.index} = obj;

% set up the local data
localData = layoutUD.optimdata;

% Card three should always be visited
nextCardID = @i_createCardThree;
return



%------------------------------------------------------------------------
% CARD THREE FUNCTIONS BELOW
%------------------------------------------------------------------------
function o__________CARD_THREE_Assign_Variables
%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function layout = i_createCardThree(fh, iFace, localData)
% GUI Layout for card three: Assign Variables

% Have we been called to create the layout or simply update?
if isa(fh, 'xregcontainer')
    layout = fh;
    layoutUD = get(layout, 'userdata'); 
else
    % Draw the ListView control
    SC = xregGui.SystemColorsDbl;
    
    layoutUD.List = actxcontainer(...
        xregGui.listview(...
        [0 0 1 1],fh));
    set(layoutUD.List,'hideselection',0);
    set(layoutUD.List,'FullRowSelect',1);
    set(layoutUD.List,'labeledit',1);
    % make the columns for the listview
    Cols= layoutUD.List.ColumnHeaders;
    Str={'Symbol','CAGE Variable'};
    cwid= [140 100];
    for n=1:2
        colItem= invoke(Cols,'Add');
        set(colItem,'text',Str{n});
        set(colItem,'width',cwid(n));
    end
    set(layoutUD.List,'View',3);
    
    % Make a title for this ListView
    t= uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'horizontalalignment','left',...
        'String','Optimization inputs:');
    layoutUD.selbutton= xregGui.iconuicontrol('parent',fh,...
        'imageFile', xregrespath('leftarrow.bmp'),...
        'transparentColor', [255 255 0],...
        'ToolTip','Select CAGE Variable',...
        'visible','off',...
        'callback',{@i_select,iFace});
    t2= uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'horizontalalignment','left',...
        'String','CAGE variables:');
    layoutUD.namelist=uicontrol('parent',fh,...
        'style','listbox',...
        'visible','off',...
        'tag','Symlist2',...
        'backgroundcolor', SC.WINDOW_BG,...
        'string','');
    
    layout = xreggridbaglayout(fh, ...
        'dimension', [5 3], ...
        'gapx', 10, ...
        'border', [7 0 7 10], ...
        'rowsizes', [15 5 -1 80 -1], ...
        'colsizes', [-1 80 -1], ...
        'colratios', [2 0 1], ...
        'mergeblock', {[3 5], [1 1]}, ...
        'mergeblock', {[3 5], [3 3]}, ...
        'elements', {t, [], layoutUD.List, [],[], ...
            [],[],[], layoutUD.selbutton, [], ...
            t2, [], layoutUD.namelist, [], []});
    infostr = 'Match each required variable in the optimization to a variable from the Variable Dictionary.';
    layout = i_maketitlearea(fh, 'Required Variables', infostr, layout);
    layoutUD.cancelFcn = @i_cardCancel;
end

if nargin > 2,
    layoutUD.optimdata = localData;
end

layoutUD = i_cardThreeUpdate(layoutUD, iFace);
set(layout, 'userdata', layoutUD);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function layoutUD = i_cardThreeUpdate(layoutUD, iFace)

optim = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};

% fills the card with information
ListItems= layoutUD.List.ListItems;

invoke(ListItems,'Clear');

% fill the left-hand list box, symbol
valLabels =get(optim, 'allvaluelabels');
for i =1: length(valLabels)
    hand{i} =invoke(ListItems,'add');
    set(hand{i},'text', valLabels{i});
end

globalUD = feval(iFace.getUserData);
pN = globalUD.Project.getdd;
cgvarptrs = pN.listptrs('variable');
cgvarnames = pveceval(cgvarptrs, @getname);

% put the cage variable names in the rhs listbox
set(layoutUD.namelist, 'string', cgvarnames);
if isempty( cgvarnames ),
    % if there are no cage variables, disable the select button
    set( layoutUD.selbutton, 'Enable', 'Off' );
end

opvallabels = get(optim, 'oppointvaluelabels');
opvalues    = get(optim, 'oppointvalues');
values      = get(optim, 'values');
valuelabels = get(optim, 'valuelabels');

for i=1:length(valLabels)
    % fill the left-hand list box
    % first look to see if they are already matched 
    
    label = get(hand{i}, 'text');
    matchptr = [];
    
    % is the label for a the free variable? 
    matchind = find(strcmp(label, get(optim, 'valuelabels')));
    if isempty(matchind)   
        % is the label for a oppoint variable? 
        for j =1:length(opvallabels)
            tmp{j} = find(strcmp(label, opvallabels{j}));
            if ~isempty(tmp{j})
                matchind = tmp{j}(1);
                % found the oppoint variable
                matchptr = opvalues{j}(matchind);
            end
        end
    else % found the matching pointer as a free variable
        matchptr = values(matchind);
    end

    if ~isempty(matchptr) & isvalid(matchptr)
        index = strmatch(matchptr.getname, cgvarnames, 'exact'); 
    else % try matching on name
        % Do not automatically match
        index = [];
    end

    if ~isempty(index)
        set(hand{i},'SubItems',1, cgvarnames{index});
        % set values in optim if the label is a free value label
        freeind = find(strcmp(label, valuelabels));
        if ~isempty(freeind)
            values = get(optim, 'values');
            values(freeind) = cgvarptrs(index);
            optim = set(optim, 'values', values);
        end
        
        % set the data set values in optim
        for j =1:length(opvallabels)
            dsind = strcmp(label, opvallabels{j});
            if any(dsind)
                opvalues{j}(dsind) = cgvarptrs(index);
                optim = set(optim, 'oppointvalues', opvalues);
            end
        end
    else % nothing found, nothing to match to
        set(hand{i},'SubItems',1, '');
    end
    
    if  i==1
        i_UpdateNamelist(layoutUD.namelist, index);
    end
   
end

layoutUD.cgvarnames = cgvarnames; 
layoutUD.cgvarptrs  = cgvarptrs;
layoutUD.optimdata.info.list{layoutUD.optimdata.info.index} = optim;

layoutUD.nextFcn   = @i_cardThreeNext;
layoutUD.finishFcn = @i_cardSixFinish;

i_CardThreeEnableNextFinish( layoutUD, iFace );

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_CardThreeEnableNextFinish( layoutUD, iFace )
% Enable/disable the 'Next' and 'Finish' buttons for card three
obj = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};

canLeaveCard = i_CanLeaveCardThree( layoutUD );
isCardLast   = isempty( get( obj, 'objectiveFuncs' ) ) ...
    && isempty( get( obj, 'constraints' ) ) ...
    && isempty( get( obj, 'oppoints' ) );

if canLeaveCard,
    feval(iFace.setFinishButton, 'On' );
    
    if isCardLast,
        feval(iFace.setNextButton, 'Off');
    else
        feval(iFace.setNextButton, 'On');
    end
else
    feval( iFace.setFinishButton, 'Off' );
    feval( iFace.setNextButton,   'Off' );
end


%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function ok = i_CanLeaveCardThree( layoutUD )
% This function determines if the user may advance from card three.
% Both the 'Next' and 'Finish' buttons should be disabled if this function 
% returns FALSE.
% 

optim = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};
values = get( optim, 'values' );
% are all value pointers valid
valOK = [];
for i = 1:length( values )
    valOK(i) = isvalid( values(i) );
end
if ~all( valOK )
    ok = 0;
    return
end    

dsvalues = get( optim, 'oppointvalues' );
% are all dataset pointers valid
for i = 1:length( dsvalues )
    dsOK = [];
    for j = 1:length( dsvalues{i} )
        dsOK(j) = isvalid( dsvalues{i}(j) );
    end
    if ~all(dsOK)
        ok = 0;
        return
    end
end

ok = 1;

%------------------------------------------------------------------------
% function i_select
%------------------------------------------------------------------------
function i_select(swish, event,iFace);

layoutUD = feval(iFace.getCardUserdata);

% get handles
target=layoutUD.List.selecteditem;
curlst=layoutUD.namelist;

% get the variable name to change
AllNames=get(curlst,'string');
Ind= get(curlst,'value');
curName=AllNames{Ind};
curPtr = layoutUD.cgvarnames(Ind);

optim = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};

% set the target name to be curname
set(target,'subitems',1,curName);

label = get(target,'text');

% set values if the label is a free value label
freeind = find(strcmp(label, get(optim, 'valuelabels')));
if ~isempty(freeind)
    values = get(optim, 'values');
    values(freeind) = layoutUD.cgvarptrs(Ind);
    optim = set(optim, 'values', values);
end

% set the data set values
opvallabels = get(optim, 'oppointvaluelabels');
opvalues = get(optim, 'oppointvalues');
for i =1:length(opvallabels)
    if ~isempty(opvallabels{i})
        dsind = find(strcmp(label, opvallabels{i}));
        opvalues{i}(dsind) = layoutUD.cgvarptrs(Ind);
    end
end
optim = set(optim, 'oppointvalues', opvalues);

% Get the cursor selection
curInd= double(target.index);   

% Get the number of nodes
N= layoutUD.List.Listitems.Count;

newInd= mod(curInd+1,double(N)+1);
% make sure indexing starts from 1 not 0
if newInd==0,newInd=1;end
newItem= get(layoutUD.List,'Listitems',newInd);
set(layoutUD.List,'selecteditem',newItem);
layoutUD.optimdata.info.list{layoutUD.optimdata.info.index} = optim;

if isempty(layoutUD.cgvarnames)
    % disable the select button when there are no CAGE inputs
    set(layoutUD.selbutton,'enable', 'off');
else
    set(layoutUD.selbutton,'enable', 'on');
end

i_CardThreeEnableNextFinish( layoutUD, iFace );

feval(iFace.setCardUserdata, layoutUD);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [nextCardID, localData] = i_cardThreeNext(layoutUD, iFace)
% set up the local data
localData = layoutUD.optimdata;

% Which card is next?
obj = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};

if ~isempty( get( obj, 'objectiveFuncs' ) ),
    % number of obj funs >= 1 ==> must vist card four
    nextCardID = @i_createCardFour;
    
elseif ~isempty( get( obj, 'constraints' ) ),
    % number of constraint >= 1 ==> must vist card five
    nextCardID = @i_createCardFive;
    
elseif ~isempty( get( obj, 'oppoints' ) ),
    % number of oppoint sets >= 1 ==> must vist card six
    nextCardID = @i_createCardSix;
    
else,
    % We really shouldn't end up here. If we are here it is because the 'Next' 
    % button hasn't been disabled. To exit smoothly, we'll just goto card six.
    warning( [ '''Next'' button not disabled on card THREE when card ', ...
            'THREE is last card.' ] );
    nextCardID = @i_createCardSix;
end
return

%------------------------------------------------------------------------
% CARD FOUR FUNCTIONS BELOW
%------------------------------------------------------------------------
function o__________CARD_FOUR_Assign_Objectives
%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function layout = i_createCardFour(fh, iFace, localData)
% GUI Layout for card four: Assign objectives

% Have we been called to create the layout or simply update?
if isa(fh, 'xregcontainer')
    layout = fh;
    layoutUD = get(layout, 'userdata');
    
else
    SC = xregGui.SystemColorsDbl;
    % Draw the ListView control
    layoutUD.List = actxcontainer(...
        xregGui.listview(...
        [0 0 1 1],fh));
    set(layoutUD.List,'hideselection',0);
    set(layoutUD.List,'FullRowSelect',1);
    set(layoutUD.List,'labeledit',1);
    % make the columns for the listview
    Cols= layoutUD.List.ColumnHeaders;
    Str={'Optimization Model','CAGE Model', 'Type'};
    cwid= [120 90 110];
    for i=1:3
        colItem{i}= invoke(Cols,'Add');
        set(colItem{i},'text',Str{i});
        set(colItem{i},'width',cwid(i));
    end
    set(layoutUD.List,'View',3);
    layoutUD.itemclick = handle.listener(layoutUD.List, 'ItemClick', {@i_ObjListCbk, iFace});
    
    % Make a title for this ListView
    t= uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'horizontalalignment','left',...
        'String','Optimization objectives:');    
    layoutUD.selbutton= xregGui.iconuicontrol('parent',fh,...
        'imageFile',xregrespath('\leftarrow.bmp'),...
        'transparentColor', [255 255 0],...
        'ToolTip','Select CAGE Model',...
        'visible','off',...
        'callback',{@i_selectObj,iFace});
    t2= uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'horizontalalignment','left',...
        'String','CAGE models:');
    layoutUD.namelist=uicontrol('parent',fh,...
        'style','listbox',...
        'visible','off',...
        'tag','Symlist2',...
        'backgroundcolor',SC.WINDOW_BG,...
        'string','');
    layoutUD.radiobutton= xregGui.rbgroup('parent',fh,...
        'nx', 3, 'ny', 1, ...
        'visible','off',...
        'string',{'Minimize', 'Maximize', 'Helper'},...
        'callback',{@i_radio,iFace});
    
    rbs = xregGui.labelcontrol('parent', fh, ...
        'Control', layoutUD.radiobutton, ...
        'string', 'Objective type:', ...
        'visible', 'off', ...
        'graydisable', 'off', ...
        'labelsizemode', 'absolute', ...
        'labelsize', 80, ...
        'controlsizemode', 'relative', ...
        'controlsize', 1,...
        'BaselineOffsetMode', 'manual');
    layout = xreggridbaglayout(fh, ...
        'dimension', [7 3], ...
        'gapx', 10, ...
        'border', [7 0 7 10], ...
        'rowsizes', [15 5 -1 80 -1 5 20], ...
        'colsizes', [-1 80 -1], ...
        'colratios', [2 0 1], ...
        'mergeblock', {[3 5], [1 1]}, ...
        'mergeblock', {[3 5], [3 3]}, ...
        'elements', {t, [], layoutUD.List, [], [], [], rbs, ...
            [], [], [], layoutUD.selbutton, [], [], [], ...
            t2, [], layoutUD.namelist});
    infostr = ['Objectives are quantities that the algorithm will attempt to optimize.', ...
            '  Select CAGE models to be used for each objective, and whether it', ...
            ' should be minimized, maximized or used as a helper model for the algorithm.'];
    layout = i_maketitlearea(fh, 'Objectives', infostr, layout);
end

if nargin > 2,
    layoutUD.optimdata = localData;
end

layoutUD = i_cardFourUpdate(layoutUD, iFace);
set(layout, 'userdata', layoutUD);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function layoutUD = i_cardFourUpdate(layoutUD, iFace)
% fills the card with information

optim = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};

% get the items in the left-hand list box
ListItems= layoutUD.List.ListItems;

% clear the left-hand list box
invoke(ListItems,'Clear');

% fill the first column of the left-hand list box
OFLabels= get(optim, 'ObjectiveFuncLabels');
for i =1: length(OFLabels)
    hand{i} =invoke(ListItems,'add');
    set(hand{i},'text', OFLabels{i});
end

% get the pointer to the cage model the model names 
OFs = get(optim, 'ObjectiveFuncs');

if layoutUD.List.ListItems.Count > 0,
   selected = layoutUD.List.selecteditem; 
   objtype = OFs(double(selected.index)).get('minstr');
else
   objtype = 'helper';
end
globalUD = feval(iFace.getUserData);
[modelptrs, modelnames] = i_FilterCAGEmodels(optim, objtype, globalUD.Project);

% put the cage model names in the rhs listbox
set(layoutUD.namelist, 'string', modelnames);

% fill the second column of the left-hand list box
for i=1:length(OFLabels)        
    modptr = OFs(i).get('modptr');
    index = [];
    if isempty(modptr);
        % No automatic  name matching 
        index = [];
    else % already have a model selected
        index = strmatch(modptr.getname, modelnames, 'exact'); 
    end

    if ~isempty(index)
        % set model in optim
        OFs = get(optim, 'ObjectiveFuncs');
        % set the model ptr in the ObjectiveFunc
        OFs(i).info = OFs(i).set('modptr',modelptrs(index));        
        set(hand{i},'SubItems',1, modelnames{index});
    else
        % Do nothing, the objective hasn't been matched...
    end
    % Handle case where user has added an objective function. These
    % functions will not be given a type by default.
    thisminstr = get(OFs(i).info, 'minstr');
    if isempty(thisminstr)
        OFs(i).info = OFs(i).set('minstr', 'min');
    end
    set(hand{i},'SubItems',2, OFs(i).tominstring);

    if  i==1
        i_UpdateNamelist(layoutUD.namelist, index);
    end
    
end
optim = set(optim, 'ObjectiveFuncs', OFs);

if layoutUD.List.ListItems.Count > 0,
    selected = layoutUD.List.selecteditem; 
    minstr = OFs(double(selected.index)).get('minstr');
    switch minstr
    case 'min'
        radiosel = 1;
    case 'max'
        radiosel = 2;
    case 'helper'
        radiosel = 3;
    otherwise 
        radiosel = 1;
    end
    
    if ~OFs(double(selected.index)).get('canswitchminmax');
        % enable just the chosen radio button
        enableArray = false(1, 3);
        enableArray(radiosel) = true;
        set( layoutUD.radiobutton, ...
            'selected', radiosel, ...
            'enableArray', enableArray);
    else
        % enable min/max
        enableArray = true(1, 3);
        enableArray(3) = false;
        set( layoutUD.radiobutton, ...
            'selected', radiosel, ...
            'enableArray', enableArray);
    end
    
else,
    % there are no items in the listview
    set( layoutUD.radiobutton, 'EnableArray', false( 1, 3 ) );
end

layoutUD.modelnames = modelnames; 
layoutUD.modelptrs =  modelptrs;
layoutUD.optimdata.info.list{layoutUD.optimdata.info.index} = optim;

layoutUD.finishFcn     = @i_cardSixFinish;

if isempty(modelnames) | isempty(OFLabels)
    % disable the select button when there are no models
    set(layoutUD.selbutton,'enable', 'off');
else
    set(layoutUD.selbutton,'enable', 'on');
end

layoutUD.nextFcn     = @i_cardFourNext;


nextOK = i_checkPtrsObjs(layoutUD);

% Can always exit from this card. The user can do the wiring in the optim
% node
feval(iFace.setFinishButton, 'on');

if nextOK
    feval(iFace.setNextButton, 'on');
else
    feval(iFace.setNextButton, 'off');
end

% --------------------------------------------------
% function i_FilterCAGEmodels
% --------------------------------------------------
function [modelptrs, modelnames] = i_FilterCAGEmodels(optim, objtype, pPROJ)

nodes = filterbytype(pPROJ.info,cgtypes.cgmodeltype);
modelptrs = [];
modelnames = [];
switch lower(objtype)
case {'max', 'min'}
   % Pointers to free vars
   pFree = get(optim, 'values');
   for i =1:length(nodes)
      pThismod = getdata(nodes{i});
      allptrs = pThismod.getptrs;
      if any(ismember(double(allptrs), double(pFree)))
         modelptrs = [modelptrs, pThismod];
         modelnames{length(modelnames) + 1} = name(nodes{i});
      end
   end   
case 'helper'
   for i =1:length(nodes)
      modelptrs = [modelptrs getdata(nodes{i})];
      modelnames{i} = name(nodes{i});
   end
end

% --------------------------------------------------
% function i_ObjListCbk
% --------------------------------------------------
function i_ObjListCbk(src, evt, iFace);

layoutUD = feval(iFace.getCardUserdata);

optim = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};
OFs = get( optim, 'ObjectiveFuncs' );
selected =layoutUD.List.selecteditem;
minstr = OFs(double(selected.index)).get('minstr');
switch minstr
case 'min'
    radiosel = 1;
case 'max'
    radiosel = 2;
case 'helper'
    radiosel = 3;
otherwise 
    radiosel = 1;
end

if ~OFs(double(selected.index)).get('canswitchminmax');
    % enable just the chosen radio button
    enableArray = false(1, 3);
    enableArray(radiosel) = true;
else
    % enable min/max
    enableArray = true(1, 3);
    enableArray(3) = false;
end
set( layoutUD.radiobutton, ...
    'selected', radiosel, ...
    'enableArray', enableArray );

% Refresh the right hand list, as models you can match depend on 
% whether the objective is min/max or helper
globalUD = feval(iFace.getUserData);
[modelptrs, modelnames] = i_FilterCAGEmodels(optim, minstr, globalUD.Project);
set(layoutUD.namelist, 'string', modelnames);

feval(iFace.setCardUserdata, layoutUD);

% --------------------------------------------------
% function i_select
% --------------------------------------------------
function i_selectObj(swish, event,iFace);

% objective function selection
layoutUD = feval(iFace.getCardUserdata);

% optim
optim = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};

% get handles
target=layoutUD.List.selecteditem;
curlst=layoutUD.namelist;

% get the model name to change
AllNames=get(curlst,'string');
Ind= get(curlst,'value');
curName=AllNames{Ind};

% set the target name to be curname
set(target,'subitems',1,curName);


label = get(target,'text');

OFs = get(optim, 'objectivefuncs');
OFind = find(strcmp(label, get(optim, 'objectivefunclabels')));
% set model in objective func
OFs(OFind).info = OFs(OFind).set('modptr',layoutUD.modelptrs(Ind));
optim = set(optim, 'objectivefuncs', OFs);

% Get the cursor selection
curInd= double(target.index);   

% Get the number of nodes
N= layoutUD.List.Listitems.Count;

newInd= mod(curInd+1,double(N)+1);
% make sure indexing starts from 1 not 0
if newInd==0,newInd=1;end
newItem= get(layoutUD.List,'Listitems',newInd);
set(layoutUD.List,'selecteditem',newItem);

% update the radio buttons
i_ObjListCbk(layoutUD.List, [], iFace);

layoutUD.optimdata.info.list{layoutUD.optimdata.info.index} = optim;


% --------------------------------------------------
% function i_radio
% --------------------------------------------------
function i_radio(radio, event,iFace);

% objective function selection
layoutUD = feval(iFace.getCardUserdata);

% optim
optim = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};

% get handles
selected =layoutUD.List.selecteditem;
curInd= double(selected.index);   

OFs = get(optim, 'objectivefuncs');

radiosel = get(radio, 'selected');

switch radiosel
case 1
    minstr = 'min';
case 2
    minstr = 'max';
case 3
    minstr = 'helper';
end
OFs(curInd).info = OFs(curInd).set('minstr', minstr);

set(selected, 'subitems', 2, OFs(curInd).tominstring);

optim = set(optim, 'objectivefuncs', OFs);

layoutUD.optimdata.info.list{layoutUD.optimdata.info.index} = optim;

feval(iFace.setCardUserdata, layoutUD);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------

function nextOK = i_checkPtrsObjs(layoutUD)

% check ptrs for the objective functions

optim = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};

OFs = get(optim, 'objectivefuncs');
% are all value pointers valid
OFOK = [];
for i = 1:length(OFs)
    OFOK(i) = isvalid(OFs(i));
end
if ~all(OFOK)
    nextOK = 0;
    return
end    

nextOK = 1;

% Check to see if there are any cons or oppts. If not, cannot go any
% further
obj = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};
if isempty( get( obj, 'constraints' )) & isempty( get( obj, 'oppoints' ) )
    nextOK = 0;
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [nextCardID, localData] = i_cardFourNext(layoutUD, iFace)

% set up the local data
localData = layoutUD.optimdata;

% Which card is next?
obj = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};

if ~isempty( get( obj, 'constraints' ) ),
    % number of constraint >= 1 ==> must vist card five
    nextCardID = @i_createCardFive;
    
elseif ~isempty( get( obj, 'oppoints' ) ),
    % number of oppoint sets >= 1 ==> must vist card six
    nextCardID = @i_createCardSix;
    
else,
    % We really shouldn't end up here. If we are here it is because the 'Next' 
    % button hasn't been disabled. To exit smoothly, we'll just goto card six.
    warning( [ '''Next'' button not disabled on card FOUR when card ', ...
            'FOUR is last card.' ] );
    nextCardID = @i_createCardSix;
end

return


%------------------------------------------------------------------------
% CARD FIVE FUNCTIONS BELOW
%------------------------------------------------------------------------
function o__________CARD_FIVE_Assign_Constraints
%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function layout = i_createCardFive(fh, iFace, localData)
% GUI Layout for card five: assign constraints

% Constraint card
% Have we been called to create the layout or simply update?
if isa(fh, 'xregcontainer')
    layout = fh;
    layoutUD = get(layout, 'userdata');
else
    SC = xregGui.SystemColorsDbl;
    % Draw the ListView control
    layoutUD.List = actxcontainer(...
        xregGui.listview(...
        [0 0 1 1],fh));
    set(layoutUD.List,'hideselection',0);
    set(layoutUD.List,'FullRowSelect',1);
    set(layoutUD.List,'labeledit',1);
    % make the columns for the listview
    Cols= layoutUD.List.ColumnHeaders;
    Str={'Model Constraint','CAGE Model', 'Bound'};
    cwid= [100 100 80];
    for i=1:3
        colItem{i}= invoke(Cols,'Add');
        set(colItem{i},'text',Str{i});
        set(colItem{i},'width',cwid(i));
    end
    set(layoutUD.List,'View',3);
    layoutUD.itemclick = handle.listener(layoutUD.List, 'ItemClick', {@i_ConListCbk, iFace});
    
    % Make a title for this ListView
    t= uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'horizontalalignment','left',...
        'String','Optimization constraints:');
    t3 = uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'horizontalalignment','left',...
        'String','Constraint:');
    layoutUD.boundtext = uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'horizontalalignment','right',...
        'String','');
    layoutUD.boundctrl = xregGui.clickedit( 'Parent', fh, ...
        'value', 0, ...
        'Visible', 'Off', ...
        'max', realmax, ...
        'BackgroundColor', SC.WINDOW_BG, ...
        'Callback', { @i_ConstraintBound, iFace } );
    layoutUD.boundtype = xreguicontrol('parent',fh,...
        'Visible', 'Off', ...
        'style', 'Popupmenu', ...
        'String', {'<=', '>='} ,...
        'BackgroundColor', SC.WINDOW_BG, ...
        'Value', 1, ...
        'Callback', { @i_ConstraintBoundType, iFace } );
    layoutUD.selbutton= xregGui.iconuicontrol('parent',fh,...
        'imageFile',xregrespath('leftarrow.bmp'),...
        'transparentColor', [255 255 0],...
        'ToolTip','Select CAGE Model',...
        'visible','off',...
        'callback',{@i_selectCon,iFace});
    t2 = uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'horizontalalignment','left',...
        'String','CAGE models:');
    layoutUD.namelist=uicontrol('parent',fh,...
        'style','listbox',...
        'visible','off',...
        'tag','Symlist2',...
        'backgroundcolor',SC.WINDOW_BG,...
        'string','');
    
    conlyt = xreggridbaglayout(fh, ...
        'dimension', [4 4], ...
        'rowsizes', [1 3 15 2], ...
        'colsizes', [60 -1 40 80], ...
        'gapx', 7, ...
        'mergeblock', {[1 4], [3 3]}, ...
        'mergeblock', {[2 4], [4 4]}, ...
        'elements', {[],[],t3, [],...
            [],[],layoutUD.boundtext, [],...
            layoutUD.boundtype, [],[],[],...
            [],layoutUD.boundctrl});
    layout = xreggridbaglayout(fh, ...
        'dimension', [7, 3], ...
        'rowsizes', [15 5 -1 80 -1 5 22], ...
        'colsizes', [-1 80 -1], ...
        'colratios', [2 0 1], ...
        'gapx', 10, ...
        'border', [7 0 7 10], ...
        'mergeblock', {[3 5], [1 1]}, ...
        'mergeblock', {[3 5], [3 3]}, ...
        'elements', {t, [], layoutUD.List, [], [], [], conlyt, ...
            [],[],[], layoutUD.selbutton, [],[],[], ...
            t2, [], layoutUD.namelist});
    infostr = ['Constraints define regions that the free variables will vary within.', ...
            '  Select CAGE models to be used for each constraint, and the value that', ...
            ' each is constrained to be greater than or less than.'];
    layout = i_maketitlearea(fh, 'Constraints', infostr, layout);   
    layoutUD.cancelFcn = @i_cardCancel;
end

if nargin > 2,
    layoutUD.optimdata = localData;
end

layoutUD = i_cardFiveUpdate(layoutUD, iFace);
set(layout, 'userdata', layoutUD);

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function layoutUD = i_cardFiveUpdate( layoutUD, iFace )
% fills the card with information

% Get the optimization object we are setting up
optim = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};

% Get the items in the left hand list box
ListItems = layoutUD.List.ListItems;

% Clear the left hand list box
invoke( ListItems, 'Clear' );

% Fill first ('Model Constraint') column of the left-hand list box
conLabels = get( optim, 'modelconstraintLabels' );
for i = 1:length( conLabels )
    hand{i} = invoke( ListItems, 'add' );
    set( hand{i}, 'text', conLabels{i} );
end

% Get candidate constraint models from the cage browser
globalUD = feval(iFace.getUserData);
proj = globalUD.Project;
nodes = filterbytype( proj.info, cgtypes.cgmodeltype );
modelptrs = [];
modelnames = {};
for i = 1:length( nodes ),
    modelptrs = [modelptrs, getdata( nodes{i} ) ];
    modelnames{i} = name( nodes{i} );
end

% Put the cage model names in the rhs listbox
set( layoutUD.namelist, 'string', modelnames );

% Fill second ('CAGE Model') column of the left-hand list box with exactly 
% matched strings
cons = get( optim, 'modelconstraints' );
boundstrings = get(layoutUD.boundtype, 'String');
for i = 1:length( conLabels ),
    label = get( hand{i}, 'text' );
    modptr = cons(i).get( 'modptr' );
    
    if ~isempty( modptr )
        index = strmatch( modptr.getname, modelnames, 'exact' ); 
    else
        % Do not do automatic name matching        
        index = []; 
    end
    
    if ~isempty( index ) 
        
        % set values in optim if the label is a free value label
        conind = find( strcmp( label, get( optim, 'modelconstraintLabels' ) ) );
        if ~isempty( conind ),
            % set the model ptr in the constraint
            cons(conind).info = cons(conind).set( 'modptr', modelptrs(index) );
            optim = set( optim, 'modelconstraints', cons );
        end
        set( hand{i}, 'SubItems', 1, modelnames{index});
    else % nothing matched
        set( hand{i}, 'SubItems', 1, '' );
    end
    
    conParams = cons(i).getparams;
    boundtext = [boundstrings{conParams.bound_type + 1} ' ' num2str(conParams.bound)];
    % set the bound data 
    set( hand{i}, 'SubItems', 2, boundtext);
    if  i==1
        i_UpdateNamelist(layoutUD.namelist, index);
    end
end

% Update the bound value and type controls
i_UpdateBoundControls( layoutUD );

% Set user data for the layput
layoutUD.optimdata.info.list{layoutUD.optimdata.info.index} = optim;
layoutUD.modelnames = modelnames; 
layoutUD.modelptrs  = modelptrs;
layoutUD.finishFcn  = @i_cardSixFinish;
layoutUD.nextFcn    = @i_cardFiveNext;

% Enable/Disable the select button: disable the when there are no models
if isempty( modelnames ) | isempty( conLabels )
    set( layoutUD.selbutton, 'enable', 'off' );
else
    set( layoutUD.selbutton, 'enable', 'on' );
end

% Enable/Disable the next and finish buttons 
nextOK = i_checkPtrsCons( layoutUD );


feval(iFace.setFinishButton, 'on');

if nextOK
    feval(iFace.setNextButton, 'on');
else
    feval(iFace.setNextButton, 'off');
end

return


% --------------------------------------------------
% 
% --------------------------------------------------
function i_UpdateBoundControls( layoutUD )
% Update the bound value and type controls based on the current selection in 
% the 'Model Constraints' listview

con = i_GetSelectedConstraint( layoutUD );
if isempty( con )
    % Disable constraint bound value and type controls
    set( layoutUD.boundctrl, 'Enable', 'Off' );
    set( layoutUD.boundtype, 'Enable', 'Off' );
    set( layoutUD.boundtext, 'string', '' );
else
    % Assign values to constraint bound value and type controls
    conParams = con.getparams;
    set( layoutUD.boundctrl, 'value', conParams.bound );
    set( layoutUD.boundtype, 'Value', conParams.bound_type + 1 );
    % Enable constraint bound value and type controls
    set( layoutUD.boundctrl, 'Enable', 'on' );
    set( layoutUD.boundtype, 'Enable', 'on' );
    % Set string of model name label
    modptr = con.get('modptr');
    if isempty(modptr)
        set( layoutUD.boundtext, 'string', '' );
    else
        set( layoutUD.boundtext, 'string', modptr.getname );
    end
end

return

% --------------------------------------------------
% function 
% --------------------------------------------------
function [constraint, index] = i_GetSelectedConstraint( layoutUD )
% Looks at the Model Constraints listview and returns the currently selected 
% constraint
% If none or many constraints are selected then []'s are returned

% Get optimization object from layout data
optim = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};

% Get list of constraints and  labels
cons   = get( optim, 'ModelConstraints' );
labels = get( optim, 'ModelConstraintLabels' );

if layoutUD.List.ListItems.Count > 0
    index = strmatch( layoutUD.List.SelectedItem.Text, labels, 'exact' );
else
    index = [];
end

if length( index ) ~= 1
    constraint = [];
else
    constraint = cons(index);
end

return

% --------------------------------------------------
% function i_ConstraintBound
% --------------------------------------------------
function i_ConstraintBound( src, evt, iFace )
value = get( src, 'value' );

% Set value in constraint object
layoutUD = feval( iFace.getCardUserdata );
con = i_GetSelectedConstraint( layoutUD );
if ~isempty( con ),
    con.info = con.setparams( 'bound', value );
end

selected =layoutUD.List.selecteditem;
strings = get(layoutUD.boundtype, 'String');
val = get(layoutUD.boundtype, 'Value');
boundtext = [strings{val} ' ' num2str(value)];
set(selected, 'subitems', 2, boundtext);
return

% --------------------------------------------------
% function i_ConstraintBoundType
% --------------------------------------------------
function i_ConstraintBoundType( src, evt, iFace )

layoutUD = feval( iFace.getCardUserdata );
con = i_GetSelectedConstraint( layoutUD );
if ~isempty( con ),
    value = get( src, 'value' );
    con.info = con.setparams( 'bound_type', value - 1 );
    
    selected =layoutUD.List.selecteditem;
    strings = get(layoutUD.boundtype, 'String');
    boundtext = [strings{value} ' ' num2str(get(layoutUD.boundctrl, 'value'))];
    set(selected, 'subitems', 2, boundtext);
end

return

% --------------------------------------------------
% function i_ConListCbk
% --------------------------------------------------
function i_ConListCbk(src, evt, iFace )
layoutUD = feval(iFace.getCardUserdata);
i_UpdateBoundControls( layoutUD );
return


% --------------------------------------------------
% function i_selectCon
% --------------------------------------------------
function i_selectCon(swish, event,iFace);

% objective function selection
layoutUD = feval(iFace.getCardUserdata);

% optim
optim = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};

% get handles
target=layoutUD.List.selecteditem;
curlst=layoutUD.namelist;

% get the model name to change
AllNames=get(curlst,'string');
Ind= get(curlst,'value');
curName=AllNames{Ind};

% set the target name to be curname
set(target,'subitems',1,curName);

label = get(target,'text');

cons = get(optim, 'modelconstraints');
conind = find(strcmp(label, get(optim, 'modelconstraintLabels')));
% set model in objective func
cons(conind).info = cons(conind).set('modptr',layoutUD.modelptrs(Ind));
optim = set(optim, 'modelconstraints', cons);

% Get the cursor selection
curInd= double(target.index);   

layoutUD.optimdata.info.list{layoutUD.optimdata.info.index} = optim;

i_UpdateBoundControls(layoutUD);


feval(iFace.setCardUserdata, layoutUD);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------

function nextOK = i_checkPtrsCons(layoutUD)

% check ptrs for the modelconstraints

optim = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};
cons = get(optim, 'modelconstraints');
% are all value pointers valid
conOK = false(size(cons));
for n = 1:length(cons)
    conOK(n) = isvalid(cons(n));
end
nextOK = all(conOK);

% Check to see if there are any cons or oppts. If not, cannot go any
% further
obj = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};
if isempty( get( obj, 'oppoints' ) )
    nextOK = 0;
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [nextCardID, localData] = i_cardFiveNext(layoutUD, iFace)

% set up the local data
localData = layoutUD.optimdata;

% Which card is next?
obj = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};

if ~isempty( get( obj, 'oppoints' ) )
    % number of oppoint sets >= 1 ==> must vist card six
    nextCardID = @i_createCardSix; 
else
    % We really shouldn't end up here. If we are here it is because the 'Next' 
    % button hasn't been disabled. To exit smoothly, we'll just goto card six.
    warning( [ '''Next'' button not disabled on card FIVE when card ', ...
            'FIVE is last card.' ] );
    nextCardID = @i_createCardSix;
end

return


%------------------------------------------------------------------------
% CARD SIX FUNCTIONS BELOW
%------------------------------------------------------------------------
function o__________CARD_SIX_Assign_OpPoint_Sets
%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function layout = i_createCardSix(fh, iFace, localData)
% GUI Layout for card six: assign OpPoint sets

% Have we been called to create the layout or simply update?
if isa(fh, 'xregcontainer')
    layout = fh;
    layoutUD = get(layout, 'userdata');
    
else
    SC = xregGui.SystemColorsDbl;
    % Draw the ListView control
    layoutUD.List = actxcontainer(...
        xregGui.listview(...
        [0 0 1 1],fh));
    set(layoutUD.List,'hideselection',0);
    set(layoutUD.List,'FullRowSelect',1);
    set(layoutUD.List,'labeledit',1);
    % make the columns for the listview
    Cols= layoutUD.List.ColumnHeaders;
    Str={'Operating Point Set','Type','CAGE Data Set'};
    cwid= [110 50 120];
    for i=1:3
        colItem{i}= invoke(Cols,'Add');
        set(colItem{i},'text',Str{i});
        set(colItem{i},'width',cwid(i));
    end
    set(layoutUD.List,'View',3);
    layoutUD.itemclick = handle.listener(layoutUD.List, 'ItemClick', {@i_ListCbk, iFace});
    
    % Make a title for this ListView we will find this and get it's user data on listview callbacks
    t= uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'horizontalalignment','left',...
        'String','Optimization operating point sets');
    layoutUD.selbutton= xregGui.iconuicontrol('parent',fh,...
        'imageFile',[xregrespath,'\leftarrow.bmp'],...
        'transparentColor', [255 255 0],...
        'ToolTip','Select CAGE Data Set',...
        'visible','off',...
        'callback',{@i_selectOpp,iFace});
    t2= uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'horizontalalignment','left',...
        'String','CAGE data sets:');
    layoutUD.namelist=uicontrol('parent',fh,...
        'style','listbox',...
        'visible','off',...
        'tag','Symlist2',...
        'backgroundcolor',SC.WINDOW_BG,...
        'string','');
    
    layout = xreggridbaglayout(fh, ...
        'dimension', [5 3], ...
        'gapx', 10, ...
        'border', [7 0 7 10], ...
        'rowsizes', [15 5 -1 80 -1], ...
        'colsizes', [-1 80 -1], ...
        'colratios', [2 0 1], ...
        'mergeblock', {[3 5], [1 1]}, ...
        'mergeblock', {[3 5], [3 3]}, ...
        'elements', {t, [], layoutUD.List, [],[], ...
            [],[],[], layoutUD.selbutton, [], ...
            t2, [], layoutUD.namelist, [], []});
    infostr = ['Select the data sets that the algorithm will use.  The "Primary"', ...
            ' operating point set contains the values of fixed variables that you', ...
            ' want the optimization to be run at.'];
    layout = i_maketitlearea(fh, 'Operating Point Sets', infostr, layout); 
    layoutUD.cancelFcn = @i_cardCancel;
end

if nargin > 2,
    layoutUD.optimdata = localData;
end

layoutUD = i_cardSixUpdate(layoutUD, iFace);
set(layout, 'userdata', layoutUD);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------

function layoutUD = i_cardSixUpdate(layoutUD, iFace)

optim = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};
% fills the card with information
ListItems= layoutUD.List.ListItems;

invoke(ListItems,'Clear');

% fill the left-hand list box
oppointLabels= get(optim, 'oppointLabels');
for i =1: length(oppointLabels)
    hand{i} =invoke(ListItems,'add');
    set(hand{i},'text', oppointLabels{i});
end


layoutUD.oppointnames = []; 
layoutUD.oppointptrs =  [];


% fill the left-hand list box with exactly matched strings
for i=length(oppointLabels):-1:1
    if i == 1
        set(hand{i},'SubItems',1,'Primary');
    else
        set(hand{i},'SubItems',1,'Helper');
    end
    % select each data set in turn
    currentItem= get(layoutUD.List,'Listitems',i);
    set(layoutUD.List,'selecteditem',currentItem);
    % update the rhs to filter the allowed data sets
    layoutUD = i_UpdateRHS(layoutUD, iFace);
    

    % Has the data set already been matched ?
    label = get(hand{i}, 'text');
    pOp = getOppointPtr(optim, label);
    if ~isempty(pOp) & isvalid(pOp)
        % Already matched
        index = strmatch(pOp.getname, layoutUD.oppointnames, 'exact'); 
    else
        % Do not do automatic name matching
        index = [];
    end
    
    
    if ~isempty(index)
        set(hand{i},'SubItems',2, layoutUD.oppointnames{index});
        opind = find(strcmp(label, get(optim, 'oppointlabels')));
        if ~isempty(opind)
            oppoints = get(optim, 'oppoints');
            oppoints(opind) = layoutUD.oppointptrs(index);
            optim = set(optim, 'oppoints', oppoints);
        end
    else % nothing matched
        set(hand{i},'SubItems',2, '');
    end
    
    if  i==1
        i_UpdateNamelist(layoutUD.namelist, index);
    end

end

layoutUD.optimdata.info.list{layoutUD.optimdata.info.index} = optim;

layoutUD.finishFcn     = @i_cardSixFinish;

if isempty(layoutUD.oppointnames) | isempty(oppointLabels) 
    % disable the select button when there are no data sets
    set(layoutUD.selbutton,'enable', 'off');
else
    set(layoutUD.selbutton,'enable', 'on');
end


% enable the finish button, disable the next button
feval(iFace.setNextButton, 'off');

feval(iFace.setFinishButton, 'on');

% --------------------------------------------------
% function i_ListCbk
% --------------------------------------------------
function i_ListCbk(src, evt, iFace);
layoutUD = feval(iFace.getCardUserdata);
layoutUD = i_UpdateRHS(layoutUD, iFace);
feval(iFace.setCardUserdata, layoutUD);

% --------------------------------------------------
% function i_UpdateRHS
% --------------------------------------------------
function layoutUD = i_UpdateRHS(layoutUD,iFace);

optim = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};

globalUD = feval(iFace.getUserData);
proj = globalUD.Project;
nodes = filterbytype(proj.info, cgtypes.cgdatasettype);
% Only allow those data sets which contain the required pointers
DSind = double(get(layoutUD.List.SelectedItem,'index'));
DSvals = get(optim, 'oppointValues');
freevals = get(optim, 'values');
if DSind == 1 % if we are the primary data set don't allow any free variables in the data set
    disallowed = freevals;
    msg = ' and do not contain one of the free variables.';
else
    disallowed = [];
    msg = '.' ;
end
nodes = i_FilterDisallowedDS(nodes, DSvals{DSind}, disallowed);
oppointptrs = [];
oppointnames = {};
for i =1: length(nodes)
    oppointptrs = [oppointptrs getdata(nodes{i})];
    oppointnames{i} = name(nodes{i});
end

set(layoutUD.namelist, 'value', 1);

% put the cage oppoints in the rhs listbox
set(layoutUD.namelist, 'string', oppointnames);

layoutUD.oppointnames = oppointnames; 
layoutUD.oppointptrs = oppointptrs;

% --------------------------------------------------
% function i_select
% --------------------------------------------------
function i_selectOpp(swish, event,iFace);

% oppoint selection
layoutUD = feval(iFace.getCardUserdata);

% optim
optim = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};

% get handles
target=layoutUD.List.selecteditem;
curlst=layoutUD.namelist;

% get the model name to change
AllNames=get(curlst,'string');
Ind= get(curlst,'value');
curName=AllNames{Ind};

% set the target name to be curname
set(target,'subitems',2,curName);

label = get(target,'text');

oppoints = get(optim, 'oppoints');
opind = find(strcmp(label, get(optim, 'oppointlabels')));
% set oppoints
oppoints(opind) = layoutUD.oppointptrs(Ind);
optim = set(optim, 'oppoints', oppoints);

% Get the cursor selection
curInd= double(target.index);   

% Get the number of nodes
N= layoutUD.List.Listitems.Count;

newInd= mod(curInd+1,double(N)+1);
% make sure indexing starts from 1 not 0
if newInd==0,newInd=1;end
newItem= get(layoutUD.List,'Listitems',newInd);
set(layoutUD.List,'selecteditem',newItem);

layoutUD = i_UpdateRHS(layoutUD,iFace);

layoutUD.optimdata.info.list{layoutUD.optimdata.info.index} = optim;

feval(iFace.setFinishButton, 'on');


feval(iFace.setCardUserdata, layoutUD);


%-------------------------------------------------------------------
function outnodes = i_FilterDisallowedDS(nodes, reqdptrs, disallowedptrs)
%-------------------------------------------------------------------

outnodes = [];
for i = 1:length(nodes)
    pOp = getdata(nodes{i});
    ptrs = get(pOp.info, 'ptrlist');
    commonPtrs = intersect(double(ptrs), double(reqdptrs));
    commonBadPtrs = intersect(double(ptrs), double(disallowedptrs));
    if length(commonPtrs) == length(reqdptrs) & isempty(commonBadPtrs)
        outnodes = [outnodes, nodes(i)];
    end
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_cardSixFinish(layoutUD, iFace)

optimindex = layoutUD.optimdata.info.index;
optimlist = layoutUD.optimdata.info.list;

otherindices = [ 1:optimindex-1, optimindex+1:length( optimlist ) ];

% Destroy all optim objects that are not used
for n = otherindices
    destroyobject( optimlist{n});
end

% return the new optimization object
outputUD.optim = layoutUD.optimdata.info.list{layoutUD.optimdata.info.index};
feval(iFace.setOutputData, outputUD);
return



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
% Need to destroy the optim objects to make sure all pointers are released
alloptims = layoutUD.optimdata.info.list;
for n = 1:length(alloptims)
    destroyobject(alloptims{n});
end

%---------------------------------------------------------
function i_UpdateNamelist(nlist, index)
%---------------------------------------------------------

% Set the value of the right hand list
if ~isempty(index)
    nmval = index;
else
    nmval = 1;
end
set(nlist, 'value', nmval);




