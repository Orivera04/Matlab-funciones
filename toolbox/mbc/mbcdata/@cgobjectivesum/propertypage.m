function [out,out2]=propertypage(obj,action,varargin)
%PROPERTYPAGE   Generate an editing page for this constraint
%
%  LYT=PROPERTYPAGE(OBJ,'CREATE',FIG,PTR,MDL,FACTORS)
%  [OK,MSG]= PROPERTYPAGE(OBJ,'FINALISE',LYT)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:50:44 $

switch lower(action)
case 'create'
   out=i_createlyt(varargin{:});
   out2=[];
case 'finalise'
   [out,out2]=i_finalise(varargin{:});
end
return

function lyt=i_createlyt(fig,ptr,optim, pPROJ)

% datasets are from the optimization
oppoints = get(optim, 'oppoints');
if isempty(oppoints)
    opptptrs = null(xregpointer,0);
else
    oppoints = oppoints(isvalid(oppoints));
end

infoptr = xregGui.RunTimePointer;
infoptr.LinkToObject(fig);

ud.ptr = ptr;
if isempty(oppoints)
    ud.enabled = false;
    infoptr.info = ud;
    infostr=uicontrol('parent',fig,...
        'style','text',...
        'enable', 'inactive', ...
        'string',['To create a sum objective you must have ', ...
            'a dataset in your optimization.']);
    lyt = xreggridbaglayout(fig,...
        'dimension',[3 3],...
        'colsizes',[20 -1 20],...
        'rowsizes', [-1 40 -1], ...
        'elements',{[], [], [], ...
            [], infostr, [], ...
            [], [], []}, ...
        'userdata', infoptr);  
else
    ud.enabled = true;
    nodes = filterbytype(pPROJ.info,cgtypes.cgmodeltype);
    modelptrs = null(xregpointer, size(nodes));
    for n =1:length(nodes)
        modelptrs(n) = getdata(nodes{n});
    end
    ud.modptrs = modelptrs;
    ud.allowedmods = false(size(modelptrs));
    ud.oppointptrs = oppoints;
    ud.optim = optim;
    
    txt = xreguicontrol('parent',fig,...
        'hittest','off',...
        'enable','inactive',...
        'visible','off',...
        'style','text',...
        'string','Available models:',...
        'horizontalalignment','left');
    ud.modptrctrl = xreguicontrol('parent',fig,...
        'visible','off',... 
        'style','listbox',...
        'backgroundcolor',[1 1 1],...
        'callback', {@i_selmodel, infoptr});
    ud.seltext = xreguicontrol('parent',fig,...
        'hittest','off',...
        'enable','inactive',...
        'visible','off',...
        'style','text',...
        'string','Selected model:',...
        'horizontalalignment','left');
    txt2 = xreguicontrol('parent',fig,...
        'hittest','off',...
        'enable','inactive',...
        'visible','off',...
        'style','text',...
        'string','Objective type:',...
        'horizontalalignment','left');
    ud.objtype = xregGui.rbgroup('parent', fig, ...
        'visible', 'off', ...
        'nx', 1, ...
        'ny', 3, ...
        'string', {'Minimize'; 'Maximize'; 'Helper'});
    txt3 = xreguicontrol('parent',fig,...
        'hittest','off',...
        'enable','inactive',...
        'visible','off',...
        'style','text',...
        'string','Operating point set:',...
        'horizontalalignment','left');
    ud.datasetsctrl = xreguicontrol('parent',fig,...
        'visible','off',...
        'style','popupmenu',...
        'backgroundcolor',[1 1 1], ...
        'callback', {@i_selds, infoptr});
    txt4 = xreguicontrol('parent',fig,...
        'hittest','off',...
        'enable','inactive',...
        'visible','off',...
        'style','text',...
        'string','Operating point weights:',...
        'horizontalalignment','left');
    ud.weightsctrl = cgoptimgui.vectorEditor('parent', fig, ...
        'visible', 'off', ...
        'layoutstyle', 'narrow');
    infoptr.info = ud;
    
    div = xregGui.dividerline('parent', fig, 'orientation', 'vertical');
    lyt = xreggridbaglayout(fig,...
        'packstatus','off', ...
        'dimension',[8 8],...
        'colsizes',[200 0 0 130 0 2 0 165],...
        'rowsizes',[15 54 0 0 15 20 -1 15],...
        'border',[0 0 0 5],...
        'gapx', 5, ...
        'gapy', 5, ...
        'mergeblock',{[2 7],[1 1]}, ...
        'mergeblock',{[8 8],[1 4]}, ...
        'mergeblock',{[2 8],[8 8]}, ...
        'mergeblock',{[1 8],[6 6]}, ...
        'elements',{txt, ud.modptrctrl, [], [], [], [], [], ud.seltext, ...
            [], [], [], [], [], [], [], [], ...
            [], [], [], [], [], [], [], [], ...
            txt2, ud.objtype, [], [], txt3, ud.datasetsctrl, [], [], ...
            [], [], [], [], [], [], [], [], ...
            div, [], [], [], [], [], [], [], ...
            [], [], [], [], [], [], [], [], ...
            txt4, ud.weightsctrl},...
        'userdata', infoptr);
    i_setuplayout(infoptr);
    i_selmodel(ud.modptrctrl, [], infoptr);
end


function i_setuplayout(infoptr)
ud = infoptr.info;
ObjFunc = ud.ptr.info;

% Set type
minstr = get(ObjFunc, 'minstr');
typeval = strmatch(minstr, {'min', 'max', 'helper'});
typeen = true(3,1);
if typeval==3
    typeen(1:2) = false;
else
    typeen(3) = false;
    if ~get(ObjFunc, 'canswitchminmax')
        typeen(1:2) = false;
        typeen(typeval) = true;
    end 
end
set(ud.objtype, 'selected', typeval, 'enablearray', typeen);

% Decide which models are available
ud.allowedmods = i_filtermodels(ud.modptrs, ud.optim, typeval);
modlist = ud.modptrs(ud.allowedmods);
modelnames = pveceval(modlist, 'getname');
pModel = get(ObjFunc, 'modptr');
if isempty(pModel)
    modelindex = 1;
else
    modelindex = find(pModel ==modlist);
    if isempty(modelindex)
        modelindex = 1;
    end
end
set(ud.modptrctrl, 'string', modelnames, 'value', modelindex);

infoptr.info = ud;

pOppoint = get(ObjFunc, 'oppoint');
dsnames = pveceval(ud.oppointptrs, 'getname');
if ~isempty(pOppoint)
    dsindex = find(pOppoint==ud.oppointptrs);
else
    dsindex = 1;
end
set(ud.datasetsctrl, 'string', dsnames, ...
    'value', dsindex);

weights = get(ObjFunc, 'weights');
Npts = ud.oppointptrs(dsindex).get('numpoints');
if length(weights) ~= Npts
    weights =  ones(Npts, 1);
end
set(ud.weightsctrl, 'vector', weights, 'DataSet', ud.oppointptrs(dsindex));



function OK = i_filtermodels(ptrs, optim, typeval);
if typeval==3
    OK = true(size(ptrs));
else
    % only allowed models that share an input with free variables
    OK = false(size(ptrs));
    pFree = get(optim, 'values');
    for n = 1:numel(OK)
        pModInputs = ptrs(n).getinports;
        OK(n) = anymember(pFree, pModInputs);
    end
end



function i_selmodel(src, evt, udh)
ud = udh.info;
str = get(src, 'string');
val = get(src, 'value');
if ~isempty(str)
    if val>0
        set(ud.seltext, 'string', sprintf('Selected model: %s', str{val}));
    end
end

function i_selds(src, evt, udh)
ud = udh.info;
val = get(src, 'value');
pOppoint = ud.oppointptrs(val);
if (pOppoint~=ud.weightsctrl.Dataset)
    % reinitialise the weights editor vector length and dataset option
    Npts = pOppoint.get('numpoints');
    if Npts~=length(ud.weightsctrl.vector)
        set(ud.weightsctrl, 'vector', ones(Npts, 1));
    end
    set(ud.weightsctrl, 'dataset', pOppoint);
end


function [ok,msg]=i_finalise(lyt)
udh = get(lyt,'userdata');
ud = udh.info;
if ud.enabled
    msg = {};
    modlist = ud.modptrs(ud.allowedmods);
    if ~isempty(modlist)
        modelindex  = get(ud.modptrctrl, 'value');
        dsindex = get(ud.datasetsctrl, 'value');
        weights = get(ud.weightsctrl, 'vector');
        objtype = get(ud.objtype, 'selected');
        switch objtype
            case 1
                minstr = 'min';
            case 2
                minstr = 'max';
            case 3
                minstr = 'helper';
        end
        ud.ptr.info = set(ud.ptr.info, ...
            'modptr', modlist(modelindex), ...
            'oppoint', ud.oppointptrs(dsindex), ...
            'weights', weights, ...
            'minstr', minstr);
    else
        msg = {'There are no models available for this kind of objective'};
    end   
else
    msg = {'You must have a dataset for a sum objective'};
end
ok = isempty(msg);