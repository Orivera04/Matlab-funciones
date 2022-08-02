function h=Callbacks(TP,subfunc,varargin)
% CALLBACKS  Various cgfeature GUI callbacks
%
%   Callbacks(TP, 'GetHandles') returns a cell array of function handles
%   to subfunctions available:
%
%     
%
%   Callbacks(TP, FUNC, ARGS) executes the iternal function FUNC and passes
%   it ARGS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.11.6.2 $    $Date: 2004/02/09 08:26:47 $

i_Message('');
if ischar(subfunc)
        if strcmp(lower(subfunc),'gethandles')
                h=struct('SetUp', @i_SetUp, ...
                 'Run', @i_Run, ...
                 'SetUpandRun', @i_SetUpandRun, ...
                 'SelObj', @i_SelObj, ...
                 'SelDS', @i_SelDS,...
                 'EditCo', @i_EditCo, ...
                 'AddObj', @i_AddObj, ...
                 'AddDS', @i_AddDS, ...
                 'AddCo', @i_AddCo,...
                 'DelObj', @i_DeleteObj, ...
                 'DelDS', @i_DeleteDS, ...
                 'DelCo', @i_DeleteCo,...
                 'Message', @i_Message, ...
                 'ListClick', @i_ListClick, ...
                 'ListRightClick', @i_ListRightClick, ...
                 'ListDblClick', @i_ListDblClick);
        end
else
        feval(subfunc,varargin{:});   
        h=[];
end
return


%---------------------------------------------------------------------------------
function d = i_GetViewData
%---------------------------------------------------------------------------------
c = cgbrowser;
d = c.getViewData;

%----------------------------------------------------------------
function i_SetViewData(d);
%----------------------------------------------------------------
c = cgbrowser;
c.setViewData(d);

%----------------------------------------------------------------
function i_SetUp(obj, nul)
%----------------------------------------------------------------

% Set Optimization parameters
CGBH = cgbrowser;
d=CGBH.getViewData;
pON = CGBH.CurrentNode;
pO = pON.getdata;

om = pO.get('om');
[om, OK] = gui_setup(om, 'figure', {'title', 'Optimization Parameters'}, xregoptmgr, cgoptimstore);
if OK 
    pO.info  = pO.set('om', om);
end

%----------------------------------------------------------------
function i_SetUpandRun(obj, nul)
%----------------------------------------------------------------

% Set up and run the optimisation
CGBH = cgbrowser;
d=CGBH.getViewData;
pON = CGBH.CurrentNode;
pO = pON.getdata;

om = pO.get('om');
[om, OK] = gui_setup(om, 'figure', {'title', 'Optimization Parameters'}, xregoptmgr, cgoptimstore);
if OK 
    pO.info  = pO.set('om', om);
    i_Run(obj, nul);
end

%----------------------------------------------------------------
function i_Run(obj, nul, varargin)
%----------------------------------------------------------------
% run the optimisation
CGBH = cgbrowser;
PR = xregGui.PointerRepository;
ptrID = PR.stackSetPointer(CGBH.Figure, 'watch');
if nargin > 2
    ON = varargin{1};
else
    pON = CGBH.CurrentNode;
    d=CGBH.getViewData;
    ON = pON.info;
end

pO = getdata(ON);

% Lock the browser
CGBH.lock;

[pO.info, anyds] = initrun(pO.info);
[pO.info, cost, OK, msg] = run(pO.info, anyds, 1, CGBH);
pO.info = clearafterrun(pO.info);

if OK == 1     
    pOut_nd = i_GetOutputNodePtr(ON);
    if isempty(pOut_nd)
       % Optimisation does not have an output node
       out_nd = cgoptimoutnode(pO, cost);
       pOut_nd = xregpointer(out_nd);    
       AddChild(ON, pOut_nd);  
       if nargin < 3
           CGBH.doDrawTree(pON, 'refresh');  
       end
    else
       % Need to update the output property of the existing output node
       pOut_nd.info = pOut_nd.setOutput(cost);
    end
    
    % Tell output node that there are new results to view
    pOut_nd.info = pOut_nd.notifyNewRes;
    
    if nargin < 3 % if optim node is current
        % print a finished message
        try
            % Remove previous message
            CGBH.removeStatusMsg(d.Handles.MessageID);
            d.Handles.MessageID = CGBH.addStatusMsg('Optimization finished.');
            CGBH.setViewData(d);
        end
        %%%%%%%%%%%%%%%%%%%%%%       
    end
elseif OK == 0
    % Display error dialog
    h = errordlg({'An error occurred during the running of the optimization.  The error was:', '',  msg}, 'Optimization Algorithm Error', 'modal');
    waitfor(h);
end

% Unlock the browser
PR.stackRemovePointer(CGBH.Figure, ptrID);
CGBH.unlock;

%----------------------------------------------------------------
function out_nd = i_GetOutputNodePtr(ON)
%----------------------------------------------------------------

out_nd = children(ON);


%----------------------------------------------------------------
function i_SelObj(obj, nul)
%----------------------------------------------------------------

CGBH = cgbrowser;
d=CGBH.getViewData;
pON = CGBH.CurrentNode;
pO = pON.getdata;

ind = pr_getListSelection(d.Handles.ObjList);

if isempty( ind )
    % no objectives - don't start editor
    return;
end

% fire the objective editor if there are models in the
% session.
proj = CGBH.RootNode;
nodes = filterbytype(proj.info,cgtypes.cgmodeltype);
if ~isempty(nodes)
    pO.info = cg_objectivegui(pO.info, ind, proj);
else
    h = i_error('There are no models in this session.', 'Set Objective Function');
    waitfor(h);
end

% Objective selected - now update the list
pr_RefreshList(d.Handles.ObjList, pON.info, d.ILmanager);
pr_EnableTM(pO.info, d.Handles);
%----------------------------------------------------------------
function i_EditCo(obj, nul)
%----------------------------------------------------------------

CGBH = cgbrowser;
d=CGBH.getViewData;
pON = CGBH.CurrentNode;
pO = pON.getdata;

ind = pr_getListSelection(d.Handles.ConList);

if isempty( ind )
    % no constraints - don't start editor
    return;
end

p.info= cg_constraintgui(pO.info, ind);
% Constraint selected - now update the list
pr_RefreshList(d.Handles.ConList, pON.info, d.ILmanager);
pr_EnableTM(pO.info, d.Handles);

%----------------------------------------------------------------
function i_SelDS(obj, nul)
%----------------------------------------------------------------

CGBH = cgbrowser;
d=CGBH.getViewData;
pON = CGBH.CurrentNode;
pO = pON.getdata;

ind = pr_getListSelection( d.Handles.DSList );
if isempty( ind )
    return;
end

% Check to see if the current data set is being used in any objective
% or constraint sums. If it is, disallow a change and inform the user
DSINSUM = i_DataSetinSum(pO, d.Handles.DSList);
if DSINSUM
    h = i_error(['This data set is used by an objective or a constraint.', ...
            '  Change this item before trying to change this operating point set'], ...
        'Set Operating Point');
    waitfor(h);
else
    [newobj, ok] = gui_datasetselector(pO.info, ind, address(pON.project));
    if ok
        pO.info = newobj;
        pr_RefreshList(d.Handles.DSList, pON.info, d.ILmanager);
        pr_EnableTM(pO.info, d.Handles);
    end
end

%----------------------------------------------------------------
function DSINSUM = i_DataSetinSum(pO, DSList)
%----------------------------------------------------------------

DSINSUM = 0;
pThisDS = i_GetCurrentDS(DSList ,pO);
objf = pO.get('objectiveFuncs');
cons = pO.get('constraints');
all2chk = [objf, cons];
for i = 1:length(all2chk)
   if issum(all2chk(i).info)  
      pOpObj = get(all2chk(i).info, 'oppoint');
      if double(pOpObj) == double(pThisDS)
         DSINSUM = 1;
         break;
      end
   end
end
      
%----------------------------------------------------------------
function pObfunc = i_GetCurrentObj(list, pO)
%----------------------------------------------------------------

% Get the position of the current objective function
ind = pr_getListSelection(list);
% Return a pointer to the selected objective function
allnames = get(pO.info, 'objectivelabels');
pObfunc = getObjectiveFunc(pO.info, allnames{ind});

%----------------------------------------------------------------
function pCofunc = i_GetCurrentCon(list, pO)
%----------------------------------------------------------------

% Get the position of the current constraint function
ind = pr_getListSelection(list);
% Return a pointer to the selected constraint function
allnames = get(pO.info, 'constraintlabels');
pCofunc = getConstraint(pO.info, allnames{ind});

%----------------------------------------------------------------
function pDS = i_GetCurrentDS(list, pO)
%----------------------------------------------------------------

% Get the position of the current constraint function
ind = pr_getListSelection(list);
if ~isempty( ind )
    % Return a pointer to the selected constraint function
    allnames = get(pO.info, 'oppointlabels');
    pDS = getOppointPtr(pO.info, allnames{ind});
else
    pDS = null( xregpointer, 0 );
end

%----------------------------------------------------------------
function i_AddObj(obj, nul)
%----------------------------------------------------------------
CGBH = cgbrowser;
d=CGBH.getViewData;
pON = CGBH.CurrentNode;
pO = pON.getdata;

pO.info = pO.addObjectiveFunc;
% Objective added - now update the list
pr_RefreshList(d.Handles.ObjList, pON.info, d.ILmanager);
%%%%%%%%%%%%% update enabling on toolbar and menus %%%%%%%%%%%%%%%%
pr_EnableTM(pO.info, d.Handles);
%----------------------------------------------------------------
function i_AddDS(obj, nul)
%----------------------------------------------------------------
CGBH = cgbrowser;
d=CGBH.getViewData;
pON = CGBH.CurrentNode;
pO = pON.getdata;

pO.info = pO.addOppoint;
pr_RefreshList(d.Handles.DSList, pON.info, d.ILmanager);
pr_RefreshInfo(d.Handles.InfoPane, pO.info);
%%%%%%%%%%%%% update enabling on toolbar and menus %%%%%%%%%%%%%%%%
pr_EnableTM(pO.info, d.Handles);
%----------------------------------------------------------------
function i_AddCo(obj, nul)
%----------------------------------------------------------------

CGBH = cgbrowser;
d=CGBH.getViewData;
pON = CGBH.CurrentNode;
pO = pON.getdata;

pO.info = pO.addConstraint;

pr_RefreshList(d.Handles.ConList, pON.info, d.ILmanager);
%%%%%%%%%%%%% update enabling on toolbar and menus %%%%%%%%%%%%%%%%
pr_EnableTM(pO.info, d.Handles);

%----------------------------------------------------------------
function i_DeleteObj(obj, nul)
%----------------------------------------------------------------
CGBH = cgbrowser;
d=CGBH.getViewData;
pON = CGBH.CurrentNode;
pO = pON.getdata;

ind = pr_getListSelection(d.Handles.ObjList);
allnames = get(pO.info, 'objectivelabels');
pO.info = pO.deleteObjectiveFunc(allnames{ind});

% Objective deleted - now update the list
pr_RefreshList(d.Handles.ObjList, pON.info, d.ILmanager);
%%%%%%%%%%%%% update enabling on toolbar and menus %%%%%%%%%%%%%%%%
pr_EnableTM(pO.info, d.Handles);

%----------------------------------------------------------------
function i_DeleteDS(obj, nul)
%----------------------------------------------------------------
CGBH = cgbrowser;
d=CGBH.getViewData;
pON = CGBH.CurrentNode;
pO = pON.getdata;

ind = pr_getListSelection(d.Handles.DSList);
allnames = get(pO.info, 'oppointlabels');

% Check to see if this data set is used in any obj/con sums. 
% If so, do not allow deletion
DSINSUM = i_DataSetinSum(pO, d.Handles.DSList);
if ~DSINSUM
   pO.info = pO.deleteOppoint(allnames{ind});
   pr_RefreshList(d.Handles.DSList, pON.info, d.ILmanager);
   pr_RefreshInfo(d.Handles.InfoPane, pO.info);
   %%%%%%%%%%%%% update enabling on toolbar and menus %%%%%%%%%%%%%%%%
   pr_EnableTM(pO.info, d.Handles);
else
   h = i_error('This data set is used by an objective or a constraint. Change this item before trying to delete this data set', 'Delete Data Set');
   waitfor(h);
end
%----------------------------------------------------------------
function i_DeleteCo(obj, nul)
%----------------------------------------------------------------

CGBH = cgbrowser;
d=CGBH.getViewData;
pON = CGBH.CurrentNode;
pO = pON.getdata;

ind = pr_getListSelection(d.Handles.ConList);
allnames = get(pO.info, 'constraintlabels');
pO.info = pO.deleteConstraint(allnames{ind});

pr_RefreshList(d.Handles.ConList, pON.info, d.ILmanager);
%%%%%%%%%%%%% update enabling on toolbar and menus %%%%%%%%%%%%%%%%
pr_EnableTM(pO.info, d.Handles);
%---------------------------------------------------------------------------------------
function i_Message(str)
%---------------------------------------------------------------------------------------

CGBH = cgbrowser;
d=CGBH.getViewData;
try
    % Remove previous message
    CGBH.removeStatusMsg(d.Handles.MessageID);
    d.Handles.MessageID = CGBH.addStatusMsg(str);
    CGBH.setViewData(d);
end

%---------------------------------------------------------------------------------------
function h = i_error(msg, title)
%---------------------------------------------------------------------------------------

h = errordlg(msg, title, 'modal');


%---------------------------------------------------------------------------------------
function i_ListRightClick(src, evt)
%---------------------------------------------------------------------------------------
CGBH = cgbrowser;
d = CGBH.getViewData;
pN = CGBH.CurrentNode;

objpos = move(src);
% Pop-up the appropriate context menu and set the enable status
switch get(src, 'UserData')
case 'Objective'
    Menu = d.Handles.Contextmenu.ObjCM;
    ListFcns(pN.info, src, 'click');
case 'Operating Point Set'
    Menu = d.Handles.Contextmenu.DSLCM;     
    ListFcns(pN.info, src, 'click');
case 'Constraint'
    Menu = d.Handles.Contextmenu.ConCM;     
    ListFcns(pN.info, src, 'click');
end
if ~isempty(Menu)
    set(Menu,'visible','off');
    set(Menu,'position',objpos(1:2) + [evt.x, evt.y], 'visible','on');
end


%---------------------------------------------------------------------------------------
function i_ListClick(src, evt)
%---------------------------------------------------------------------------------------
CGBH = cgbrowser;
d = CGBH.getViewData;
pN = CGBH.CurrentNode;

ListFcns(pN.info, src, 'click');


%---------------------------------------------------------------------------------------
function i_ListDblClick(src, evt)
%---------------------------------------------------------------------------------------  

% Launch the respective edit/select guis
switch get(src, 'UserData')
case 'Objective'
    i_SelObj([],[]);
case 'Constraint'
    i_EditCo([],[]);
case 'Operating Point Set'
    i_SelDS([],[]);
end
