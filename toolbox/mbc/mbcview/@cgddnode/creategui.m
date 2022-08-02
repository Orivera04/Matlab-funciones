function [LYT, TBLYT, ViewData] = creategui(CGND, info);
% cgDDNode Create GUI  
% [LYT, TBLYT, ViewData] = creategui(CGND, info);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.2.4 $  $Date: 2004/02/09 08:23:12 $

CGBH = info.browserH;
% Lower display to edit the selected object

ctrl= xreguicontrol('style','edit',...
   'visible','off',...
	'parent',info.Figure,...
	'horizontalalignment','left',...
	'backgroundcolor',[1 1 1],...
	'tag','cgddnode_descr',...
	'callback',@i_DescrChange);
Handles.Descr=xregGui.labelcontrol('parent',info.Figure,...
   'visible','off',...
   'string','Description:',...
   'gap',5,...
   'labelsize',80,...
   'labelsizemode','absolute',...
   'controlsize',1,...
   'controlsizemode','relative',...
   'control',ctrl);

ctrl= xreguicontrol('style','edit',...
   'visible','off',...
	'parent',info.Figure,...
	'horizontalalignment','left',...
	'backgroundcolor',[1 1 1],...
	'tag','cgddnode_alias',...
	'callback',@i_AliasChange);
Handles.Alias=xregGui.labelcontrol('parent',info.Figure,...
   'visible','off',...
   'string','Alias:',...
   'gap',5,...
   'labelsize',80,...
   'labelsizemode','absolute',...
   'controlsize',1,...
   'controlsizemode','relative',...
   'control',ctrl);

ctrl= xregGui.clickedit('visible','off',...
	'parent',info.Figure,...
	'horizontalalignment','right',...
   'dragging','off',...
	'tag','cgddnode_min',...
	'callback',@i_RangeChange);
Handles.Min=xregGui.labelcontrol('parent',info.Figure,...
   'visible','off',...
   'string','Minimum:',...
   'gap',5,...
   'labelsize',80,...
   'labelsizemode','absolute',...
   'controlsize',80,...
   'controlsizemode','absolute',...
   'control',ctrl);

ctrl= xregGui.clickedit('visible','off',...
	'parent',info.Figure,...
   'dragging','off',...
	'horizontalalignment','right',...
	'tag','cgddnode_max',...
	'callback',@i_RangeChange);
Handles.Max=xregGui.labelcontrol('parent',info.Figure,...
   'visible','off',...
   'string','Maximum:',...
   'gap',5,...
   'labelsize',80,...
   'labelsizemode','absolute',...
   'controlsize',80,...
   'controlsizemode','absolute',...
   'control',ctrl);

ctrl= xregGui.clickedit('style','edit',...
   'visible','off',...
	'parent',info.Figure,...
	'horizontalalignment','right',...
   'dragging','off',...
	'tag','cgddnode_min',...
	'callback',@i_NominalValueChange);
Handles.Const=xregGui.labelcontrol('parent',info.Figure,...
   'visible','off',...
   'string','Set Point:',...
   'gap',5,...
   'labelsize',80,...
   'labelsizemode','absolute',...
   'controlsize',80,...
   'controlsizemode','absolute',...
   'control',ctrl);

ctrl= xreguicontrol('style','edit',...
   'visible','off',...
	'parent',info.Figure,...
	'horizontalalignment','left',...
	'backgroundcolor',[1 1 1],...
   'tag','cgddnode_eq',...
   'callback', @i_FormulaChange);
Handles.Func=xregGui.labelcontrol('parent',info.Figure,...
   'visible','off',...
   'string','Formula:',...
   'gap',5,...
   'labelsize',80,...
   'labelsizemode','absolute',...
   'controlsize',1,...
   'controlsizemode','relative',...
   'control',ctrl);

LYT = xreggridbaglayout(info.Figure,...
   'packstatus','off',...
   'dimension',[5 3],...
   'rowsizes',[20 20 20 20 20],...
   'colsizes',[165 165 -1],...
   'gapy',10,...
   'gapx',10,...
   'mergeblock',{[1 1],[1 3]},...
   'mergeblock',{[2 2],[1 3]},...
   'mergeblock',{[4 4],[1 3]},...
   'mergeblock',{[5 5],[1 3]},...
   'elements',{Handles.Alias,Handles.Descr,Handles.Min,Handles.Const,Handles.Func,...
      [],[],Handles.Max},...
   'border',[10 10 10 10]);

LYT=xregpaneltitlelayout(info.Figure,'center',LYT);

Handles.Name=LYT;

% ---------------- Toolbar setup ------------------------------------------
icons{1,1} = cgresload('cgnewvariable.bmp','bmp');
icons{2,1} = cgresload('cgnewconst.bmp','bmp');
icons{3,1} = cgresload('cgnewfunc.bmp','bmp');

callbacks = {@i_NewVariable; @i_NewConstant; @i_NewFormula};

tooltips = {'New Variable';...
        'New Constant';...
        'New Formula'};

transpclr = {[0 255 0];...
        [0 255 0];...
        [0 255 0]};

[TBLYT,btns] = xregtoolbar(info.Figure,{'uipush','uipush','uipush'},...
        {'Cdata'},icons,...
        {'ClickedCallback'},callbacks,...
        {'ToolTipString'},tooltips, ...
        {'TransparentColor'},transpclr);
     
Handles.Toolbar.Variable = btns(1);
Handles.Toolbar.Constant = btns(2);
Handles.Toolbar.Formula = btns(3);

% Menus
% ---------- Create a Tools menu -------------------------------------
cgb=info.browserH;
tlmenu=cgb.createmenu(guid(CGND),1);
set(tlmenu,'label','V&ariable');

Handles.Tools(1) = uimenu(tlmenu, 'label', '&Change item to...','enable','off');
mmm = uimenu(Handles.Tools(1),'label', '&Alias','callback',@i_Eliminate);
Handles.MakeVar = uimenu(Handles.Tools(1),'label','&Variable','callback', @i_ConvToVariable,'enable','off');
Handles.MakeConst = uimenu(Handles.Tools(1),'label','&Constant','callback', @i_ConvToConstant,'enable','off');
Handles.MakeFormula = uimenu(Handles.Tools(1),'label','&Formula','callback', @i_ConvToFormula,'enable','off');


% -------- context menus ---------------------------------------------

m = cgb.makeContextMenuBase;
Handles.ContextMenu = m;
Handles.ContextChg = uimenu(m,'label','&Change item to...','separator','on');
Handles.ContextAlias = uimenu(Handles.ContextChg,'label', '&Alias','callback',@i_Eliminate);
Handles.ContextMakeVar = uimenu(Handles.ContextChg,'label','&Variable', 'callback', @i_ConvToVariable);
Handles.ContextMakeCon = uimenu(Handles.ContextChg,'label','&Constant', 'callback', @i_ConvToConstant);
Handles.ContextMakeFor = uimenu(Handles.ContextChg,'label','&Formula', 'callback', @i_ConvToFormula);

%--------------- Create the handles structure and pass to viewdata ----------------------

d.Handles = Handles;
ViewData = d;





%---------------------------------------------------------------------
function i_DescrChange(obj,nul)
%---------------------------------------------------------------------
CGBH = cgbrowser;
d=CGBH.getViewData;
pS = CGBH.CurrentSubItem;
descr = get(d.Handles.Descr.control,'string');
pS.info = pS.setdescription(descr);


%---------------------------------------------------------------------
function i_AliasChange(obj,nul)
%---------------------------------------------------------------------
CGBH = cgbrowser;
d=CGBH.getViewData;
pN = CGBH.CurrentNode;
pS = CGBH.CurrentSubItem;
alias = get(d.Handles.Alias.Control,'string');
aliaslist = strread(alias, '%s', 'delimiter', ',');

% if any of the aliases exist as other variables in the DD offer to make that
% variable an alias of this one
ddptrs = listptrs(pN.info);
for n = 1:length(ddptrs)
    name = ddptrs(n).getname;
    if ddptrs(n) == pS
        % If user types in the name of the current variable, remove it
        aliaslist(strcmp(aliaslist, name))=[];
    end
    if ismember(name, aliaslist)
        question = sprintf( 'Do you wish to make variable "%s" an alias of "%s"?', name, pS.getname);
        reply = questdlg( question , 'MBC Toolbox', 'Yes', 'No', 'No' );
        switch lower(reply)
            case 'yes'
                % bring the aliases across as well
                aliaslist = [aliaslist; ddptrs(n).getaliaslist];
                pN.info = replace(pN.info, ddptrs(n), pS);
            case 'no'
                % remove this from the list of aliases
                aliaslist(strcmp(aliaslist, name))=[];
        end
    end
end

[pS.info, nAdded, nRemoved] = setaliasstring(pS.info, sprintf('%s,', aliaslist{:}), pN);

if nRemoved
    % Remove aliases from any formulae that are using this object
    syms = pN.insymval(pS);
    if ~isempty(syms)
        passign(syms, pveceval(syms, @updatenames));
    end
end

set(d.Handles.Alias.Control,'string',pS.getaliasstring);
doDrawList(CGBH);

%---------------------------------------------------------------------
function i_NominalValueChange(obj,nul)
%---------------------------------------------------------------------
CGBH = cgbrowser;
d=CGBH.getViewData;
pN = CGBH.CurrentNode;
pS = CGBH.CurrentSubItem;
val=d.Handles.Const.Control.Value;

% The clickedit already confines to real numeric input for us
if isinf(val)
   CGBH.addTimedStatusMsg('Constants must be numeric, real and finite.',5);   
   % refresh view with current item's data
   CGBH.ViewNode;
else
   % Update item and refresh list
   oldval = pS.getnomvalue;
   pS.info = pS.setnomvalue(val);
   [dd, ok, msg, pSym] = updateformulae(pN.info, pS);
   if ~ok
       showerrordialog(pSym.info, msg, 'Formula Error', ...
           ['The set point could not be altered because it caused the following errors in formula ' pSym.getname ':']);
       % revert to old value
       pS.info = pS.setnomvalue(oldval);
       d.Handles.Const.Control.Value = oldval;
   else
       % update value as well
       pS.info = pS.setvalue(val);
       % Update list
       mySym = pN.insymval(pS);
       CGBH.doDrawList('update', pN, [pS, mySym]);
   end
end


%---------------------------------------------------------------------
function i_RangeChange(obj,nul)
%---------------------------------------------------------------------
CGBH = cgbrowser;
d=CGBH.getViewData;
pN = CGBH.CurrentNode;
pS = CGBH.CurrentSubItem;
R1 = d.Handles.Min.Control.Value;
R2 = d.Handles.Max.Control.Value;
R=[R1 R2];  
% Clickedit's force input to be real, and ascending
if any(isinf(R))
   CGBH.ViewNode; 
else
   % Check to see if set point now lies outside range. 
   % If so try to reset it
   oldsp = pS.getnomvalue;
   oldR = pS.getrange;
   if oldsp > R(2)
       newsp = R(2);
       CHANGE_NOMVALUE = true;
   elseif oldsp < R(1)
       newsp = R(1);
       CHANGE_NOMVALUE = true;       
   else
       newsp = oldsp;
       CHANGE_NOMVALUE = false;
   end
   
   updateptrs = pS;
   if CHANGE_NOMVALUE
       pS.info = pS.setrange(R);
       if pS.issymvalue
           pVar = pS.getvariable;
           oldVarsp = pVar.getnomvalue;
           VarR = pVar.getrange;
           oldVarR = VarR;
           pS.setnomvalue(newsp);
           % Check variable's range is ok
           if newsp<VarR(1)
               VarR(1) = newsp;
           elseif newsp>VarR(2)
               VarR(2) = newsp;
           end
           pVar.info = pVar.setrange(VarR);
           [dd, ok, msg, pSym] = updateformulae(pN.info, pVar);
           if ~ok
               showerrordialog(pSym.info, msg, 'Formula Error', ...
                   ['The set point could not be altered because it caused the following errors in formula ' pSym.getname ':']);
               % revert to old values
               pVar.info = pVar.setnomvalue(oldVarsp);
               pVar.info = pVar.setrange(oldVarR);
               pS.info = pS.setrange(oldR);
               UPDATE_GUI = false;
           else
               pVar.info = pVar.setvalue(newsp);
               UPDATE_GUI = true;
               updateptrs = [pVar, pN.insymval(pVar)];
           end
       else
           pS.info = pS.setnomvalue(newsp);
           [dd, ok, msg, pSym] = updateformulae(pN.info, pS);
           if ~ok
               showerrordialog(pSym.info, msg, 'Formula Error', ...
                   ['The set point could not be altered because it caused the following errors in formula ' pSym.getname ':']);
               % revert to old values
               pS.info = pS.setnomvalue(oldsp);
               pS.info = pS.setrange(oldR);
               UPDATE_GUI = false;
           else
               % update value as well
               pS.info = pS.setvalue(newsp);
               UPDATE_GUI = true;
               updateptrs = [updateptrs, pN.insymval(pS)];
           end
       end
   else
       pS.info = pS.setrange(R);
       if pS.issymvalue 
           % Check this equation
           [flags, msg] = checkevaluation(pS.info);
           if ~all(flags)
               % Show error dialog
               showerrordialog(pS.info, msg, 'Formula Error', ...
                   'The range could not be altered because it caused the following errors in this formula:');
               % Revert to previous settings
               pS.info = pS.setrange(oldR);
               UPDATE_GUI = false;
           else
               UPDATE_GUI = true;
           end
       else
           UPDATE_GUI = true;
       end
       
   end
   
   if UPDATE_GUI
       %reset max/min limits on boxes
       d.Handles.Min.Control.Max=R2-eps;
       d.Handles.Max.Control.Min=R1+eps;
       % Reset max/min limits of set point control
       d.Handles.Const.Control.Min=R1+eps;
       d.Handles.Const.Control.Max=R2-eps;
       % Update list
       CGBH.doDrawList('update',pN,updateptrs);
   else
       % revert inputs to previous values
       d.Handles.Min.Control.Value = oldR(1);
       d.Handles.Max.Control.Value = oldR(2);
   end
end


%---------------------------------------------------------------------------------------
function i_FormulaChange(obj, nul)
%---------------------------------------------------------------------------------------

CGBH = cgbrowser;
d = CGBH.getViewData;
pS = CGBH.CurrentSubItem;
pDD = CGBH.CurrentNode;

neweq = get(d.Handles.Func.Control,'string');
obj = pS.info;
[obj, flags, msg, newptrs] = setequation(obj, neweq, pDD);
ok = all(flags);
if ok
    % check the formula evaluates
    [flags, msg] = checkevaluation(obj);
    ok = all(flags);
end
if ~ok
    % remove any new pointers from dictionary
    for n = 1:length(newptrs)
        pDD.remove(newptrs);
    end
    showerrordialog(obj, msg, 'Edit Formula');
    set(d.Handles.Func.Control,'string', pS.getequation);
else
    % Refresh
    pS.info = obj;
    doDrawList(CGBH,'refresh');
    CGBH.ViewNode; 
end
return


%---------------------------------------------------------------------------------------
function i_NewVariable(obj,nul)
%---------------------------------------------------------------------------------------

% Function to add a new variable

CGBH = cgbrowser;
pstack=xregGui.PointerRepository;
pID=pstack.stackSetPointer(CGBH.Figure,'watch');

pN = CGBH.CurrentNode;
[dd,pNew] = newvariable(pN.info);

CGBH.doDrawList;
CGBH.gotonode(pN,pNew);  
pstack.stackRemovePointer(CGBH.Figure,pID);


%---------------------------------------------------------------------------------------
function i_NewConstant(obj,nul)
%---------------------------------------------------------------------------------------

% Function to add a new constant

CGBH = cgbrowser;
pstack=xregGui.PointerRepository;
pID=pstack.stackSetPointer(CGBH.Figure,'watch');

pN = CGBH.CurrentNode;
[dd,pNew] = newconstant(pN.info);

CGBH.doDrawList;
CGBH.gotonode(pN,pNew);  
pstack.stackRemovePointer(CGBH.Figure,pID);


%---------------------------------------------------------------------------------------
function i_NewFormula(obj,nul)
%---------------------------------------------------------------------------------------

% Function to add a new formula
CGBH = cgbrowser;
pstack=xregGui.PointerRepository;
pID=pstack.stackSetPointer(CGBH.Figure,'watch');

pN = CGBH.CurrentNode;
[dd,pNew] = newformula(pN.info);

if pNew~=0
   CGBH.doDrawList;
   CGBH.gotonode(pN,pNew);  
end
pstack.stackRemovePointer(CGBH.Figure,pID);


%---------------------------------------------------------------------------------------
function i_Eliminate(obj,nul)
%---------------------------------------------------------------------------------------
CGBH = cgbrowser;
pN = CGBH.CurrentNode;
pS = CGBH.CurrentSubItem;
[dd, ok, pNew] = eliminateitem(pN.info, pS);
if ok
    CGBH.doDrawList;
    CGBH.gotonode(pN,pNew);
end


%---------------------------------------------------------------------------------------
function i_ConvToFormula(obj,nul)
%---------------------------------------------------------------------------------------
CGBH = cgbrowser;
pN = CGBH.CurrentNode;
pS = CGBH.CurrentSubItem;
Nitemsnow = getnumitems(pN.info);
[ok, msg] = convtoformula(pN.info, pS);
if ok
    if getnumitems(pN.info)>Nitemsnow
        % Items have been added
        CGBH.doDrawList;
    else
        CGBH.doDrawList('update', pN, pS);
    end
    CGBH.ViewNode;
elseif ~isempty(msg)
    h = errordlg(msg, 'Convert to Formula', 'modal');
    waitfor(h);    
end

%---------------------------------------------------------------------------------------
function i_ConvToConstant(obj,nul)
%---------------------------------------------------------------------------------------
CGBH = cgbrowser;
pN = CGBH.CurrentNode;
pS = CGBH.CurrentSubItem;
[ok, msg] = convtoconstant(pN.info, pS);
if ok
    CGBH.doDrawList('update', pN, pS);
    CGBH.ViewNode;
elseif ~isempty(msg)
    h = errordlg(msg, 'Convert to Constant', 'modal');
    waitfor(h);    
end

%---------------------------------------------------------------------------------------
function i_ConvToVariable(obj,nul)
%---------------------------------------------------------------------------------------
CGBH = cgbrowser;
pN = CGBH.CurrentNode;
pS = CGBH.CurrentSubItem;
[ok, msg] = convtovariable(pN.info, pS);
if ok
    CGBH.doDrawList('update', pN, pS);
    CGBH.ViewNode;
elseif ~isempty(msg)
    h = errordlg(msg, 'Convert to Variable', 'modal');
    waitfor(h);    
end