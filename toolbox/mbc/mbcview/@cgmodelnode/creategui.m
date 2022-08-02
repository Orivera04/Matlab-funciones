function [LYT, TBLYT, d] = creategui(CGND, info)
%CREATEGUI Create the browser UI for models
%
%  [LYT, TBLYT, ViewData] = CREATEGUI(CGND, info)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.4.4 $  $Date: 2004/04/04 03:33:27 $

% ---------------- Menu setup ---------------
cgb = info.browserH;
menus = cgb.createmenu(guid(CGND),2);
set(menus,{'label'},{'&View'; '&Model'});

conmenu = uimenu(menus(1), 'label', 'Connections &Graph');
uimenu(conmenu, 'Label', '&Reset Zoom', 'callback', {@i_resetzoom, info.browserH});
uimenu(conmenu, 'Label', 'Zoom &In', 'callback', {@i_alterzoom, info.browserH, 1.5});
uimenu(conmenu, 'Label', 'Zoom &Out', 'callback', {@i_alterzoom, info.browserH, 0.666});
uimenu(conmenu, 'Label', 'Zoom To &Fit', 'callback', {@i_zoomtofit, info.browserH});
d.DispConstraintsMenu = uimenu(menus(1), 'label', 'Display &Constraints', ...
    'separator', 'on', ...
    'enable', 'off', ...
    'callback', {@i_toggleconstraints, cgb});
uimenu(menus(1), 'Label', 'Edit Input &Set Points...', ...
    'callback', {@i_editnomvalues, info.browserH});


d.EditModel = uimenu(menus(2) , 'label' , 'Edit &Inputs...' , ...
    'callback' , {@i_EditInputsThis, info.browserH});
d.ChangeFuncModel = uimenu(menus(2) , 'label' , 'Edit &Function...'  , ...
    'callback' , {@i_ChangeFunctionModel, info.browserH});
d.LoadMBCModel = uimenu(menus(2) , 'label' , '&Open in Model Browser'  , ...
    'callback' , {@i_loadmodel, info.browserH});
uimenu(menus(2) , 'label' , '&Properties' , ...
    'separator', 'on', ...
    'callback' , {@i_ModelInformation, info.browserH});

% ------------- List Context menu ---------------
d.NodeContextMenu = info.browserH.makeContextMenuBase;
uimenu(d.NodeContextMenu , 'label' , '&Properties' , ...
    'separator', 'on', ...
    'callback' , {@i_ModelInformation, info.browserH});

% ---------------- Toolbar setup --------------
TBLYT = xregGui.uitoolbar(info.Figure, ...
    'visible','off', ...
    'ResourceLocation', cgrespath);

icons = {'cgnewfuncmodel.bmp'; ...
    'cgeditinputs.bmp'; ...
    'cgchangefunc.bmp'; ...
    'propdialog.bmp'};
callbacks = {...
    {@i_NewFunctionModel, info.browserH};...
    {@i_EditInputsThis, info.browserH};...
    {@i_ChangeFunctionModel, info.browserH};...
    {@i_ModelInformation, info.browserH} };
tooltips = {'New Function Model';...
    'Edit Inputs';...
    'Edit Function';...
    'Model Properties'};
transpclr = repmat({[0 255 0]}, 4, 1);
seps = {'off'; 'on'; 'off'; 'on'};

[TBLYT,btns] = xregtoolbar(TBLYT,{'uipush','uipush','uipush','uipush'},...
    {'ImageFile'},icons,...
    {'ClickedCallback'},callbacks,...
    {'ToolTipString'},tooltips, ...
    {'TransparentColor'},transpclr, ...
    {'Separator'}, seps);
d.ChangeFuncModelBtn = btns(3);

% --------- Context menus for expression view ---------

cmenu = uicontextmenu('parent', info.Figure, ...
    'callback',{@i_CheckContextMenu, info.browserH});
uimenu(cmenu,'label','View Model', 'callback' ,{@i_ViewModel, info.browserH});
uimenu(cmenu,'label','Edit Inputs...', 'callback' ,{@i_EditInputsContext, info.browserH});

zoomcmenu = uicontextmenu('parent', info.Figure);
uimenu(zoomcmenu, 'Label', '&Reset Zoom', 'callback', {@i_resetzoom, info.browserH});
uimenu(zoomcmenu, 'Label', 'Zoom &In', 'callback', {@i_alterzoom, info.browserH, 1.5});
uimenu(zoomcmenu, 'Label', 'Zoom &Out', 'callback', {@i_alterzoom, info.browserH, 0.666});
uimenu(zoomcmenu, 'Label', 'Zoom To &Fit', 'callback', {@i_zoomtofit, info.browserH});

% ---------------- Layout setup ------------
d.ExprView = cgtools.exprview('Parent', info.Figure, ...
    'visible', 'off', ...
    'blockcontextmenu', cmenu, ...
    'maincontextmenu', zoomcmenu);
d.ModelView = cgtools.modelview('Parent', info.Figure, ...
    'visible', 'off');

ExprViewPanel = xregpaneltitlelayout(info.Figure, ...
    'visible', 'off', ...
    'packstatus', 'off', ...
    'title', 'Connections', ...
    'center', d.ExprView);

LYT = xregsnapsplitlayout(info.Figure,...
    'visible', 'off', ...
    'elements',{ExprViewPanel, d.ModelView},...
    'barstyle',1,...
    'snapstyle','tozero',...
    'minwidth',[50 50]);

% Flag that helps optimise view/show methods
d.SkipViewUpdate = false;


function i_ViewModel(src, evt, cgb)
d = cgb.getViewData;

% The pointer to the new model expression
ptr = d.ExprView.SelectedExpression;

% Find the node that contains this pointer
proj = project(cgb.CurrentNode.info);
nds = findprimarynode(proj, ptr);
if ~isempty(nds)
    cgb.CurrentNode = nds(1);
end


function i_ModelInformation(src, evt, cgb)
cn = cgb.currentnode;
PR = xregGui.PointerRepository;
ptrID = PR.stackSetPointer(cgb.Figure, 'watch');
[node, changed] = displayInfo(cn.info);
if changed
    cgb.ViewNode;
end
PR.stackRemovePointer(cgb.Figure, ptrID);


function i_EditInputsThis(src, evt, cgb)
pNode = cgb.currentnode;
pModel = pNode.getdata;
i_EditInputs(cgb, pModel);

function i_EditInputsContext(src, evt, cgb)
d = cgb.getViewData;
pModel = d.ExprView.SelectedExpression;
i_EditInputs(cgb, pModel);

function i_EditInputs(cgb, pModel)
localdata.modptr = pModel;
localdata.models = {pModel.get('model')};
title = sprintf('Edit Inputs: %s', pModel.getname);
[OK, ignore] = xregwizard(cgf, title, {@cg_model_wizard 'cardthree'}, localdata);
if OK
    i_InputsChanged(cgb, pModel);
end

function i_InputsChanged(cgb, pModel)
% Update the nodes in the list that use this model
nodeptr = cgb.currentnode;
cgb.doDrawList('update',nodeptr);

% Need complete refresh - model may have different number of non-constant inputs
cgb.ShowNode;
cgb.ViewNode;


function i_ChangeFunctionModel(src, evt, cgb)
pNode = cgb.currentnode;
pModel = pNode.getdata;
this = pModel.get('model');
[oldN,oldS] = nfactors(this);
str = char(this);
Answer = inputdlg('Function string:','Edit Function',1,{str});
if ~isempty(Answer) && ~strcmp(Answer{1},str)
    this = setfunction(this, Answer{1});
    [N,S] = nfactors(this);
    OK = true;
    if oldN == N
        for i = 1:N
            OK = OK && isequal(oldS{i},S{i});
        end
    else
        OK = false;
    end
    if OK
        pModel.info = pModel.set('model', this);
        cgb.doDrawList('update',pNode);
        cgb.ViewNode;
    else
        h = errordlg(['The input arguments to the function cannot be changed.' ...
            '  The function has not been updated.'], ...
            'MBC Toolbox', 'modal');
        waitfor(h);
    end
end


function i_NewFunctionModel(src, evt, cgb)
PR = xregGui.PointerRepository;
ptrID = PR.stackSetPointer(cgb.Figure,'watch');
msgID = cgb.addStatusMsg('Creating new function model...');

% we are creating a new model in the model wizard, not adjusting an old one
localdata.modptr = [];
localdata.models = [];

% call the model wizard
[OK, out] = xregwizard(cgb.Figure,...
    'Function Model Wizard',...
    {@cg_model_wizard 'cardfour'},...
    localdata);

if OK
    mod = out.CageModels;
    objp = xregpointer(mod{1});
    ndP = cgnode(objp.info,[],objp,1);

    prnt = cgb.CurrentNode;
    if prnt==0;
        prnt=cgb.RootNode;
    end
    % add items to project
    addnodestoproject(prnt.info,ndP);
    cgb.doDrawList;
    % go to new node
    cgb.gotonode(ndP,xregpointer);
end

cgb.removeStatusMsg(msgID);
PR.stackRemovePointer(cgb.Figure,ptrID);



function i_CheckContextMenu(src, evt, cgb)
d = cgb.getViewData;
CurrModel = d.ExprView.SelectedExpression;

% First menu is "Edit Inputs".  Second is "View Model".
submenus = get(src,'children');
if ~isnull(CurrModel)
    if CurrModel.isa('cgmodexpr')
        set(submenus(1),'enable','on');
        if d.ExprView.RootExpression == CurrModel
            set(submenus(2),'enable','off');
        else
            set(submenus(2),'enable','on');
        end
    else
        set(submenus,'enable','off');
    end
else
    set(submenus,'enable','off');
end


% Load an MBC model into the Model Browser
function i_loadmodel(src, evt, cgb)
PR = xregGui.PointerRepository;
ptrID = PR.stackSetPointer(cgb.Figure,'watch');
msgID = cgb.addStatusMsg('Opening Model Browser...');

pNode = cgb.currentnode;
pModel = pNode.getdata;
mdl = pModel.get('model');
if isa(mdl, 'xregstatsmodel');
    ok = loadmodel(mdl);
    if ~ok
        h = errordlg('MBC Toolbox', ...
            ['An error occurred while trying to open the model in the Model Browser.  ', ...
            'Check that the original project file is on your MATLAB path'], ...
            'modal');
        waitfor(h);
    end
end
cgb.removeStatusMsg(msgID);
PR.stackRemovePointer(cgb.Figure,ptrID);


function i_resetzoom(src, evt, cgb)
d = cgb.getViewData;
d.ExprView.ZoomFactor = 1;

function i_alterzoom(src, evt, cgb, factor)
d = cgb.getViewData;
d.ExprView.ZoomFactor = d.ExprView.ZoomFactor * factor;

function i_zoomtofit(src, evt, cgb)
d = cgb.getViewData;
d.ExprView.zoomToFit;

function i_toggleconstraints(src, evt, cgb)
d = cgb.getViewData;
PR = xregGui.PointerRepository;
ptrID = PR.stackSetPointer(cgb.Figure, 'watch');
if d.ModelView.DisplayConstraints
    d.ModelView.DisplayConstraints = false;
    set(src, 'Checked', 'off');
else
    d.ModelView.DisplayConstraints = true;
    set(src, 'Checked', 'on');
end
PR.stackRemovePointer(cgb.Figure, ptrID);


function i_editnomvalues(src, evt, cgb)
cn = cgb.CurrentNode;
pExpr = cn.getdata;

ischanged = cgeditnomvalues(pExpr.getdditems);
if any(ischanged)
    PR = xregGui.PointerRepository;
    ptrID = PR.stackSetPointer(cgb.Figure, 'watch');
    cgb.ViewNode;
    PR.stackRemovePointer(cgb.Figure, ptrID);
end
