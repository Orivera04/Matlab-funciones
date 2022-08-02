function varargout = cg_model_wizard(action, varargin)
%CG_MODEL_WIZARD  Model import/creation wizard
%
%  CG_MODEL_WIZARD provides the cards and interface functions required by
%  xregwizard to display the model import wizard in cage
%
%  [OK, OUT] = XREGWIZARD(FIGPARENT , TITLE, {@cg_model_wizard 'cardxxx'}, localdata);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.12.2.5 $  $Date: 2004/04/04 03:36:45 $

switch lower(action)
    case 'cardtwo' 
        % select models to import
        [varargout{1:nargout}] = i_createCardTwo(varargin{:});
    case 'cardthree'
        % signal assignment
        [varargout{1:nargout}] = i_createCardThree(varargin{:});
    case 'cardfour'
        % enter formula for function model
        [varargout{1:nargout}] = i_createCardFour(varargin{:});
end


%------------------------------------------------------------------------
% CARD TWO FUNCTIONS BELOW
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function layout = i_createCardTwo(fh, iFace, localData)


% Have we been called to create the layout or simply update?
if isa(fh, 'xregcontainer')
    layout = fh;
    layoutUD = get(layout, 'userdata');
else
    check = xregGui.uicontrol('parent', fh,...
        'callback', {@i_automatic, iFace},...
        'style', 'checkbox',...
        'string', 'Automatically assign/create inputs', ...
        'value', 0,...
        'visible', 'off');   
    button = xregGui.uicontrol('parent', fh,...
        'callback', {@i_selectall, iFace},...
        'style', 'pushbutton',...
        'string', 'Select All',...
        'visible', 'off');    
    txModels = xregGui.uicontrol('parent', fh,...
        'style', 'text',...
        'string', 'Select models:',...
        'visible', 'off',...
        'horizontal', 'left');
    
    h = xregGui.listview([0 0 1 1],fh);
    set(h, 'view', 3, ...
        'labeledit', 1, ...
        'hideselection', 0, ...
        'fullrowselect', 1, ...
        'sorted', 0, ...
        'parent', fh, ...
        'multiselect', 1); 

    cols = {'Model Name' 'Inputs' 'Description'};
    width = [100 120 270];
    hCols = h.ColumnHeaders;
    for i = 1:length(cols)
        hItem = hCols.Add; 
        hItem.text = cols{i};
        hItem.width = width(i);
    end
    
    layout = xreggridbaglayout(fh,...
        'dimension', [6 2], ...
        'rowsizes', [15 2 -1 10 10 15], ...
        'colsizes', [65 -1], ...
        'border', [10 0 10 10], ...
        'gapx', 20, ...
        'mergeblock', {[1 1] [1 2]}, ...
        'mergeblock', {[3 3] [1 2]}, ...
        'mergeblock', {[5 6] [1 1]}, ...
        'elements', {txModels [] actxcontainer(h) [] button [], ...
        [] [] [] [] [] check });
    
    layoutUD.txModels = txModels;
    layoutUD.ModelList = h;
    layoutUD.nextFcn = @i_cardTwoNext;
    layoutUD.finishFcn = @i_cardTwoFinish;  
end

if nargin > 2
    layoutUD.models   = localData.models;
    layoutUD.modptr   = localData.modptr;
end

feval(iFace.setFinishButton, 0);
feval(iFace.setNextButton, 1);

i_cardTwoUpdate(layoutUD, iFace);
set(layout, 'userdata', layoutUD);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_cardTwoUpdate(layoutUD, iFace)

% Set model information
ModelList = layoutUD.ModelList;
ModelList.ListItems.Clear;
for i = 1:length(layoutUD.models)
    item = ModelList.ListItems.Add; 
    set(item, 'text', getname(layoutUD.models{i})); 
    [nf, Symbols, u] = nfactors(layoutUD.models{i});
    varstr = [];
    for j = 1:length(Symbols)
        varstr = [varstr Symbols{j} ', ']; 
    end
    set(item, 'SubItems', 1, varstr(1:end-2));
    if isa(layoutUD.models{i}, 'cgfuncmodel')
        set(item, 'SubItems', 2, get(layoutUD.models{i},'function'));
    end
end

firstitem = ModelList.ListItems.Item(1);
set(layoutUD.ModelList,'selecteditem',firstitem);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_automatic(obj, event, iFace)

% when automatic wiring is checked
flag = get(obj, 'value');

if flag 
    feval(iFace.setFinishButton, 1);
    feval(iFace.setNextButton, 0);
else
    feval(iFace.setFinishButton, 0);
    feval(iFace.setNextButton, 1);
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_selectall(obj, event, iFace)

% select all models
layoutUD = feval(iFace.getCardUserdata);

h= layoutUD.ModelList.ListItems;
for i=1:double(h.Count)
    Item= h.Item(i);
    set(Item,'selected',1);
end


%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_cardTwoFinish(layoutUD, iFace)

%autowire

%get the selected models

indices = layoutUD.ModelList.SelectedItemIndex;

models = layoutUD.models(indices);

cgh = cgbrowser;
proj = cgh.rootnode;
dd = proj.getdd;
vals = dd.listptrs;


layoutUD.CageModels = [];

valNames = {};
for i=1:length(vals)
    valNames = [valNames;{vals(i).getname}];
end
%unique value names
[valNames,i,j] = unique(valNames);
% unique value pointers
vals = vals(i);


% filter to find exisiting model nodes
modn = proj.filterbytype(cgtypes.cgmodeltype);
modp = [];
modNames = [];
for i=1:length(modn)
    % model pointers
    modp = [modp getdata(modn{i})];
    % model names
    modNames = [modNames;{modp(i).getname}];
end

for i = 1:length(models)
    M = models{i};
    R = getranges(M);
    str = getname(M);
    if isempty(str)
        str = 'New_Model';
    end
    %Now, we want to get the inputs sorted out.
    [n,s,u]=nfactors(M);
    Minput = [];
    for j = 1:n
        matchptr = dd.find(s{j});
        if ~isempty(matchptr) %matches a variable in the dictionary, including aliases
            Minput = [Minput; matchptr];
        else 
            index = strmatch(s{j}, modNames, 'exact');
            if ~isempty(index) %factor name matches a model
                Minput = [Minput; modp(index)];
            else % nothing matched
                % and add a variable to the data dictionary names s{j}
                [dd.info, newVal] = add(dd.info, s{j});
                newVal.info = newVal.set('range',[R(1,j) R(2,j)]); 
                newVal.info = newVal.set('value',R(1,j));
                newVal.info = newVal.set('setpoint', mean(R(:,j)));
                Minput = [Minput;newVal];
                vals = [vals;newVal];
                valNames = [valNames;s(j)];
            end
        end
    end
    
    if ~isempty(layoutUD.modptr)
        modptr = layoutUD.modptr;
        %update the model inside the modexpr
        modptr.info = modptr.set('model',M); 
        modptr.info = modptr.set('ptrlist' , Minput);
    else % when a new model is being created
        cagemod = cgmodexpr;
        cagemod = setname(cagemod , str);
        cagemod = set(cagemod , 'model' , M);
        cagemod = set(cagemod , 'ptrlist' , Minput);
        layoutUD.CageModels{i} = cagemod;
    end
end


outputUD.CageModels= layoutUD.CageModels;
feval(iFace.setOutputData, outputUD);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [nextCardID, localData] = i_cardTwoNext(layoutUD, iFace)

% get selected models
indices = layoutUD.ModelList.SelectedItemIndex;

% check for no selections
if (length(indices)==1 && indices==-1) || isempty(indices)
    uiwait(errordlg('You must select at least one model before continuing.', ...
        'Model Selection Error', 'modal'));
    nextCardID = [];
    localData = [];
    return
end

models = layoutUD.models(indices);

localData.models = models;
localData.modptr = layoutUD.modptr; 

nextCardID = @i_createCardThree;

%------------------------------------------------------------------------
% CARD THREE FUNCTIONS BELOW
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function layout = i_createCardThree(fh, iFace, localData)
% Have we been called to create the layout or simply update?
if isa(fh, 'xregcontainer')
    layout = fh;
    layoutUD = get(layout, 'userdata');
else
    % Draw the ListView control
    List = actxcontainer(...
        xregGui.listview(...
        [0 0 1 1],fh));
    set(List,'hideselection',0);
    set(List,'FullRowSelect',1);
    set(List,'labeledit',1);
    % make the columns for the listview
    Cols= List.ColumnHeaders;
    Str={'Symbol','Assigned Input'};
    cwid= [120 120];
    for i=1:2
        colItem = invoke(Cols,'Add');
        set(colItem,'text',Str{i});
        set(colItem,'width',cwid(i));
    end
    set(List,'View',3);
    layoutUD.ClickList = handle.listener(List, 'Click', {@i_SignalListClick, iFace});
    layoutUD.KeyList = handle.listener(List, 'KeyUp', {@i_SignalListKey, iFace});

    selbutton= xregGui.iconuicontrol('parent',fh,...
        'imageFile',[xregrespath,'\leftarrow.bmp'],...
        'transparentColor', [255 255 0],...
        'ToolTip','Select Input',...
        'visible','off',...
        'callback',{@i_select,iFace});    
    CopyRange=uicontrol('parent',fh,...
        'style','checkbox',...
        'visible','off',...
        'string','Copy range');
    selBrdr= xreggridbaglayout(fh,...
        'packstatus', 'off', ...
        'dimension',[5,1],...
        'elements',{[],selbutton,[],CopyRange,[]},...
        'rowsizes',[10 80 5 20 -1]);

    MTitle = uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'horizontalalignment','left',...
        'String','Model factors:');
    DTitle= uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'horizontalalignment','left',...
        'String','Available inputs:');
    
    % listbox with all Names
    namelist=uicontrol('parent',fh,...
        'style','listbox',...
        'visible','off',...
        'tag','Symlist2',...
        'backgroundcolor',[1 1 1],...
        'string','',...
        'callback', {@i_selectvar,iFace});
    
    %Factor Range
    t= uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'HorizontalAlignment','left',...
        'String','Factor range:',....
        'position',[0 0 80 15]);
    t2= uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'HorizontalAlignment','left',...
        'String','Output clips:',....
        'position',[0 0 80 15]);
    Mrange(1)= uicontrol('parent',fh,...
        'style','edit',...
        'backgroundcolor',[1 1 1],...
        'visible','off',...
        'HorizontalAlignment','left',...
        'position',[0 0 80 15],...
        'callback',{@i_ChangeRange,iFace});
    Mrange(2)= uicontrol('parent',fh,...
        'style','edit',...
        'backgroundcolor',[1 1 1],...
        'visible','off',...
        'HorizontalAlignment','left',...
        'position',[0 0 80 15],...
        'callback',{@i_ChangeRange,iFace});
    OutRange(1)= uicontrol('parent',fh,...
        'style','edit',...
        'backgroundcolor',[1 1 1],...
        'visible','off',...
        'HorizontalAlignment','left',...
        'position',[0 0 80 15],...
        'callback',{@i_ChangeOutRange,iFace});
    OutRange(2)= uicontrol('parent',fh,...
        'style','edit',...
        'backgroundcolor',[1 1 1],...
        'visible','off',...
        'HorizontalAlignment','left',...
        'position',[0 0 80 15],...
        'callback',{@i_ChangeOutRange,iFace});
    
    GM= xreggridbaglayout(fh,'dimension',[7 3],...
        'rowsizes', [3 15 2 5 3 15 2], ...
        'colsizes',[-1 60 60],...
        'gapx',10, ...
        'mergeblock', {[1 3], [2 2]}, ...
        'mergeblock', {[1 3], [3 3]}, ...
        'mergeblock', {[5 7], [2 2]}, ...
        'mergeblock', {[5 7], [3 3]}, ...
        'elements',{[], t, [], [], [], t2, [], ...
        Mrange(1), [], [], [], OutRange(1), [], [], ...
        Mrange(2), [], [], [], OutRange(2)});
    
    %Cage input Range 
    t= uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'HorizontalAlignment','left',...
        'String','Input range:',....
        'position',[0 0 80 15]);
    Drange(1)= uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'HorizontalAlignment','left',...
        'position',[0 0 80 15]);
    Drange(2)= uicontrol('parent',fh,...
        'style','text',...
        'visible','off',...
        'HorizontalAlignment','left',...
        'position',[0 0 80 15]);
    DM= xreggridbaglayout(fh,'dimension',[1 3],...
        'colsizes',[-1 60 60],...
        'elements',{t,Drange(1),Drange(2)},...
        'gapx',10);
    
    layout = xreggridbaglayout(fh,...
        'dimension',[5 3],...
        'border',[10 0 10 10],...
        'gapx',10,...
        'rowsizes',[15 2 -1 10 45],...
        'colsizes',[-1 80 -1], ...
        'elements',{MTitle, [], List, [], GM, ...
            [], [], selBrdr, [], [], ...
            DTitle, [], namelist, [], DM});
    
    layoutUD.List = List;
    layoutUD.namelist = namelist;
    layoutUD.Mrange = Mrange;
    layoutUD.OutRange = OutRange;
    layoutUD.Drange = Drange;
    layoutUD.CopyRange = CopyRange;
    layoutUD.selbutton = selbutton;
    
    set(layout,'packstatus','on');
end

if nargin >2
    layoutUD.models = localData.models;
    layoutUD.modptr = localData.modptr;
end

% fill the card with information
layoutUD = i_cardThreeUpdate(layoutUD, iFace);
set(layout, 'userdata', layoutUD);


%------------------------------------------------------------------------
%
%------------------------------------------------------------------------

function layoutUD = i_cardThreeUpdate(layoutUD, iFace)

models = layoutUD.models;

% fills the card with information
ListItems= layoutUD.List.ListItems;

% clear the old left-hand list
ListItems.Clear; 

% fill the left-hand list box

% get all variable from all models
modvar = [];
for i =1:length(models)
    [nf,Symbols, u] = nfactors(models{i});
    modvar = [modvar; Symbols(:)];
end
modvar = unique(modvar);

hand = cell(1, length(modvar));
for i =1: length(modvar)
    hand{i} = ListItems.Add;
    set(hand{i},'text', modvar{i});
end

% fill the rhs list box
layoutUD = i_InputList(layoutUD);


if ~isempty(layoutUD.modptr)
    modptr = layoutUD.modptr;
    ptrs = modptr.get('ptrlist');
    % fill the left-hand list box with the strings of the already matched variables
    for i=1: length(ptrs)
        symind = find(strcmp(Symbols{i}, modvar)); % where does the symbol occur in the list?
        target = ListItems.Item(symind);   
        
        index = strmatch(ptrs(i).getname, layoutUD.inputNames, 'exact'); 
        if index
            set(target,'SubItems',1, layoutUD.inputNames{index});
        else
            set(target,'SubItems',1, ''); 
        end
    end
else
    c = cgbrowser;
    ddn = c.DataDictionary;
    
    % fill the left-hand list box with exactly matched strings
    for i=1: length(modvar)
        matchptr = ddn.find(modvar{i});
        if ~isempty(matchptr) %matches a variable in the dictionary
            index = strmatch(matchptr.getname, layoutUD.inputNames, 'exact'); 
            set(hand{i},'SubItems',1, layoutUD.inputNames{index});
        else % does the string match a model? 
            index = strmatch(modvar{i}, layoutUD.inputNames, 'exact');
            if ~isempty(index)
                set(hand{i},'SubItems',1, layoutUD.inputNames{index});
            else % nothing matched
                set(hand{i},'SubItems',1, '');
            end
        end
    end
end

% set model ranges
layoutUD = i_setmodelrangesboxes(layoutUD,1);

%set cage input ranges
layoutUD = i_setvarranges(layoutUD,1);


layoutUD.finishFcn     = @i_cardThreeFinish;

% enable the finish button, disable the next button
feval(iFace.setNextButton, 'off');
feval(iFace.setFinishButton, 'on');

% --------------------------------------------------------
% function i_InputList
% --------------------------------------------------------

function layoutUD = i_InputList(layoutUD)

%Set up a list of available inputs to the exportmodel
cgb = cgbrowser;
proj = cgb.rootnode;
ddn = cgb.DataDictionary;
ddvariables = ddn.listptrs;

% filter to find model nodes
modn = proj.filterbytype(cgtypes.cgmodeltype);

layoutUD.inputList = [];

layoutUD.inputNames = [];
for i = 1:length(ddvariables)
    layoutUD.inputList = [layoutUD.inputList ddvariables(i)];
    layoutUD.inputNames{i} = ddvariables(i).getname;
end

for j = 1:length(modn)
    modj = getdata(modn{j});
    % if we are wiring an existing model, cannot input the model, or models that contain the model
    if  isempty(layoutUD.modptr) ...
            || ~anymember(layoutUD.modptr, [modj; modj.getptrs])
        layoutUD.inputList = [layoutUD.inputList modj];
        layoutUD.inputNames = [layoutUD.inputNames {modj.getname}];
    end
end

% put the cage variable names in the rhs listbox
set(layoutUD.namelist, 'string', layoutUD.inputNames);

if isempty(layoutUD.inputNames)
    % disable the select button when there are no CAGE inputs
    set(layoutUD.selbutton,'enable', 'off');
end

% --------------------------------------------------
% function i_select
% --------------------------------------------------
function i_select(swish, event,iFace)

layoutUD = feval(iFace.getCardUserdata);

% get handles
target=layoutUD.List.selecteditem;
curlst=layoutUD.namelist;

% get the variable name to change
AllNames=get(curlst,'string');
Ind= get(curlst,'value');
curName=AllNames{Ind};

% set the target name to be curname
set(target,'subitems',1,curName);

% Get the cursor selection
curInd= double(target.index);	

if get(layoutUD.CopyRange,'value')
    layoutUD = i_copyModelRange(layoutUD);
end


layoutUD = i_setmodelrangesboxes(layoutUD,curInd);


feval(iFace.setCardUserdata, layoutUD);






%------------------------------------------------------------------------
%
%------------------------------------------------------------------------

function layoutUD = i_setmodelrangesboxes(layoutUD, varargin)

if nargin <2
    ind= double(get(layoutUD.List.SelectedItem,'index'));
else
    ind = varargin{1};
end

if isempty(ind)
    % Clear the edit boxes
    set(layoutUD.Mrange(1),'string','' );
    set(layoutUD.Mrange(2),'string','' );
    set(layoutUD.OutRange(1),'string','');
    set(layoutUD.OutRange(2),'string','');
    return
end
% work out which models the factor is in
models = layoutUD.models;
for i =1:length(models)
    [nf,Symbols,U]= nfactors(models{i});
    Item = layoutUD.List.Listitems.Item(ind);
    label = get(Item,'text');
    varind = find(strcmp(label, Symbols)); % where does the label occur in the list of symbols?
    if varind
        Bnds= getranges(layoutUD.models{i});
        set(layoutUD.Mrange(1),'string',num2str(Bnds(1, varind)) );
        set(layoutUD.Mrange(2),'string',num2str(Bnds(2, varind)) );
    end
    
end
M = layoutUD.modptr;
if isempty(M)
    Clips = [-inf inf];
else
    Clips = M.get('clips');
end
ClipLow = num2str(Clips(1));
ClipHigh = num2str(Clips(2));
set(layoutUD.OutRange(1),'string',ClipLow);
set(layoutUD.OutRange(2),'string',ClipHigh);

% --------------------------------------------------------
%  function i_copyModelRange
% --------------------------------------------------------
function  layoutUD = i_copyModelRange(layoutUD)


% work out which models the factor is in
models = layoutUD.models;
for i =1:length(models)
    [nf,Symbols,U]= nfactors(models{i});
    label = get(layoutUD.List.SelectedItem,'text');
    varind = find(strcmp(label, Symbols)); % where does the label occur in the list of symbols?
    if varind % if the symbol is in the ith model
        
        R = getranges(models{i});
        vals= get(layoutUD.Drange(:),'userdata');
        vals= [vals{:}];
        if ~isempty(vals) %if there are ranges to transfer
            if vals(1)==vals(2)
                if vals(1)==0
                    vals(2)=1;
                else
                    vals(2)= vals(1)*1.1;
                end
            end
            
            R(:,varind)= vals(:);
            models{i} = setranges(models{i},R);
        end
    end   
end

layoutUD.models = models;

% ---------------------------------
%
%------------------------------------------------------------------------

function layoutUD = i_setvarranges(layoutUD, varargin)

if nargin <2
    ind= get(layoutUD.namelist,'value');
else
    ind = varargin{1};
end

inputs = layoutUD.inputList;
if ~isempty(inputs)
    try
        R = get(inputs(ind).info, 'range');
        if isempty(R)
            R = [-1 1];
        end
        set(layoutUD.Drange(1),'string',num2str(R(1)),'userdata',R(1));
        set(layoutUD.Drange(2),'string',num2str(R(2)),'userdata',R(2));
    catch
        set(layoutUD.Drange(1),'string','','userdata',[]);
        set(layoutUD.Drange(2),'string','','userdata',[]);
    end
end


% --------------------------------------------------------
% function i_ChangeRange
% --------------------------------------------------------
function i_ChangeRange(obj, event, iFace)

% callback 
layoutUD = feval(iFace.getCardUserdata);

% work out which models the factor is in
models = layoutUD.models;

for i =1:length(models)
    [nf,Symbols,U]= nfactors(models{i});
    label = get(layoutUD.List.SelectedItem,'text');
    varind = find(strcmp(label, Symbols)); % where does the label occur in the list of symbols?
    if varind % if the symbol is in the ith model
        R = getranges(models{i});
        
        strings= get(layoutUD.Mrange,'string');
        vals = str2num(strings{1});
        vals = [vals str2num(strings{2})];
        if length(vals)==2 && (vals(1)<vals(2)) % if sensible ranges are entered
            R(:,varind)= vals(:);
            models{i} = setranges(models{i},R);
        else % revert
            set(layoutUD.Mrange(1),'string',num2str(R(1,varind)));
            set(layoutUD.Mrange(2),'string',num2str(R(2,varind)));          
        end
    end   
end



layoutUD.models = models;

feval(iFace.setCardUserdata, layoutUD);

% --------------------------------------------------------
% function i_ChangeOutRange
% --------------------------------------------------------
function i_ChangeOutRange(obj, event, iFace)

% callback 
layoutUD = feval(iFace.getCardUserdata);
% Get modelexpr
M = layoutUD.modptr.info;
% Get new values and check by doing a set then a get
ClipLow = str2num(get(layoutUD.OutRange(1),'string'));
ClipHigh = str2num(get(layoutUD.OutRange(2),'string'));
M = set(M,'clips',[ClipLow ClipHigh]);
Clips = get(M,'clips');
set(layoutUD.OutRange(1),'string',num2str(Clips(1)));
set(layoutUD.OutRange(2),'string',num2str(Clips(2)));
% Update modelexpr
layoutUD.modptr.info = M;
%------------------------------------------------------------------------
%
%------------------------------------------------------------------------

function i_selectvar(obj, event, iFace)

%callback from cage variable list

layoutUD = feval(iFace.getCardUserdata);

ind = get(layoutUD.namelist, 'value');

layoutUD = i_setvarranges(layoutUD,ind);


feval(iFace.setCardUserdata, layoutUD);


%------------------------------------------------------------------------
%  Callbacks from the signal list
%------------------------------------------------------------------------

function i_SignalListClick(src, evt, iFace)
i_ListCbk(iFace);

function i_SignalListKey(src, evt, iFace)
if (evt.KeyCode~=16) && (evt.KeyCode~=17)
    % Filter out Ctrl and Shift key presses
    i_ListCbk(iFace);
end

function i_ListCbk(iFace)
layoutUD = feval(iFace.getCardUserdata);
ind= double(get(layoutUD.List.SelectedItem,'index'));
layoutUD = i_setmodelrangesboxes(layoutUD,ind);
feval(iFace.setCardUserdata, layoutUD);


%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_cardThreeFinish(layoutUD, iFace)

%get the selected models
models = layoutUD.models;

cgh = cgbrowser;
proj = cgh.rootnode;
dd = proj.getdd;

layoutUD.CageModels = [];

inputList = layoutUD.inputList;
inputNames = layoutUD.inputNames;

N = double(get(layoutUD.List.ListItems,'count'));
for k = 1:N
    item = layoutUD.List.ListItems.Item(k); 
    labels{k} = get(item,'text');
end


for i = 1:length(models)
    M = models{i};
    R = getranges(M);
    str = getname(M);
    if isempty(str)
        str = model;
    end
    
    %Now, we want to get the inputs sorted out.
    [nf,Symbols,U]= nfactors(M);
    
    Minput = [];
    for j=1: nf % for each symbol, assign a cage input
        
        symind = find(strcmp(Symbols{j}, labels)); % where does the symbol occur in the list?
        
        target = layoutUD.List.ListItems.Item(symind);   
        
        inputname = target.SubItems(1);
        
        if ~isempty(inputname) % if assigned
            inputind = find(strcmp(inputname, inputNames)); % where does the input occur in the available input list?
            Minput = [Minput; inputList(inputind)];
        else %if left blank
            [dd.info, newVal] = add(dd.info, Symbols{j});
            newVal.info = newVal.set('range',[R(1,j) R(2,j)]); 
            newVal.info = newVal.set('value',R(1,j));
            newVal.info = newVal.set('setpoint',mean(R(:,j)));
            %E = append(E,newVal);
            Minput = [Minput; newVal];
            inputList = [inputList newVal];
            inputNames = [inputNames Symbols(j)];
            
        end    
    end
    
    if ~isempty(layoutUD.modptr)
        modptr = layoutUD.modptr;
        %update the model inside the modexpr
        modptr.info = modptr.set('model',M); 
        modptr.info = modptr.set('ptrlist' , Minput);
    else % when a new model is being created
        cagemod = cgmodexpr;
        cagemod = setname(cagemod , str);
        cagemod = set(cagemod , 'model' , M);
        cagemod = set(cagemod , 'ptrlist' , Minput);
        layoutUD.CageModels{i} = cagemod;
    end
end


outputUD.CageModels= layoutUD.CageModels;
feval(iFace.setOutputData, outputUD);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------

function layout = i_createCardFour(fh, iFace, localData)

if isa(fh, 'xregcontainer')
    layout = fh;
else
    txPrompt = xregGui.uicontrol('parent', fh,...
        'style', 'text',...
        'horizontal','left',...
        'string', 'Enter formula for function model (e.g. ratio = x/y):',...
        'visible','off');   
    txEdFormula =  xregGui.uicontrol('parent', fh,...
        'style', 'edit',...
        'horizontal','left',...
        'background',[1 1 1],...
        'visible','off');
    layout = xreggridbaglayout(fh,...
        'dimension', [4 1],...
        'rowsizes', [-1 15 20 -1],...
        'gapy', 2, ...
        'border', [30 0 30 0], ...
        'elements', {[] txPrompt txEdFormula []});
    
    layoutUD.txEdFormula = txEdFormula;
    layoutUD.nextFcn    = @i_cardFourNext;
 
    if nargin > 2
        layoutUD.models = localData.models;
        layoutUD.modptr = localData.modptr;   

        if ~isempty(layoutUD.modptr) % if we are adjusting an existing function model
            rhs = get(layoutUD.models{1},'function');
            name = getname(layoutUD.models{1});
            set(layoutUD.txEdFormula, 'string', [name ' = ' rhs]);
        end
    else
        layoutUD.models = [];
        layoutUD.modptr = [];   
    end

    set(layout, 'userdata', layoutUD);
end

feval(iFace.setFinishButton, 'off');
feval(iFace.setNextButton,   1);


%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [nextCardID, localData] = i_cardFourNext(layoutUD, iFace)

[OK, layoutUD] = i_Parse(layoutUD, iFace);

if OK
    localData.models = layoutUD.models;
    localData.modptr = layoutUD.modptr;

    nextCardID = @i_createCardTwo;
else
    nextCardID = [];
    localData = [];
end


%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [ok, layoutUD]=i_Parse(layoutUD, iFace)

ok = 0;

string = get(layoutUD.txEdFormula,'string');
if isempty(string)
    h = errordlg('You must enter a formula string.' , ...
        'Function Model Error' , 'modal');
    waitfor(h);
    return
end

eqindx = findstr(string , '=');

if isempty(eqindx)
    h = errordlg('Your formula should include an equals sign.' , ...
        'Function Model Error' , 'modal');
    waitfor(h);
    return
end

% split the name on the left from the formula on the right
name = string(1:eqindx-1);
string = string(eqindx+1:end);

Funcmod = cgfuncmodel;
Funcmod = setname(Funcmod, name);
[Funcmod, ok, msg] = setfunction(Funcmod, string);
if ok
    L = nfactors(Funcmod);
    layoutUD.models = { set(Funcmod,'range',repmat([0;100],1,L)) };
    feval(iFace.setCardUserdata, layoutUD);
else
    h = errordlg(msg , 'Function Model Error' , 'modal');
    uiwait(h);
end


