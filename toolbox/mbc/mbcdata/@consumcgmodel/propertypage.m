function [out,out2]=propertypage(obj,action,varargin)
%PROPERTYPAGE   Generate an editing page for this constraint
%
%  LYT=PROPERTYPAGE(OBJ,'CREATE',FIG,PTR,MDL,FACTORS)
%  [OK,MSG]= PROPERTYPAGE(OBJ,'FINALISE',LYT)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.1 $    $Date: 2004/02/09 06:56:19 $

switch lower(action)
    case 'create'
        out=i_createlyt(obj,varargin{:});
        out2=[];
    case 'finalise'
        [out,out2]=i_finalise(varargin{:});
end
return


%---------------------------------------------------------------------
function lyt=i_createlyt(obj, fig,ptr,mdl,fact)
%---------------------------------------------------------------------

CGBH = cgbrowser;
pPROJ = CGBH.RootNode;
pN = CGBH.currentnode;
pO = pN.getdata;

% all cage models are listed
nodes = filterbytype(pPROJ.info,cgtypes.cgmodeltype);
modelptrs = null(xregpointer, size(nodes));
for n =1:length(nodes)
    modelptrs(n) = getdata(nodes{n});
end

% datasets are from the optimization
oppoints = pO.get('oppoints');
if isempty(oppoints)
    oppoints = null(xregpointer,0);
else
    oppoints = oppoints(isvalid(oppoints));
end

infoptr = xregGui.RunTimePointer;
infoptr.LinkToObject(fig);

ud.ptr = ptr;
if isempty(oppoints) || isempty(modelptrs)
    ud.enabled = false;
    infoptr.info = ud;
    infostr=uicontrol('parent',fig,...
        'style','text',...
        'enable', 'inactive', ...
        'string',['To create a model sum constraint you must have ', ...
            'models in your CAGE session and a dataset in your optimization.']);
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
    ud.modptrs = modelptrs;
    ud.oppointptrs = oppoints;
    
    txt = xreguicontrol('parent',fig,...
        'hittest','off',...
        'enable','inactive',...
        'visible','off',...
        'style','text',...
        'string','Available models:',...
        'horizontalalignment','left');
    ud.modptrctrl=xreguicontrol('parent',fig,...
        'visible','off',... 
        'style','listbox',...
        'backgroundcolor',[1 1 1],...
        'callback', {@i_selmodel, infoptr});
    txt2=xreguicontrol('parent',fig,...
        'hittest','off',...
        'enable','inactive',...
        'visible','off',...
        'style','text',...
        'string','Constraint type and bound:',...
        'horizontalalignment','left');
    ud.boundctrl= xregGui.clickedit('parent',fig,...
        'visible','off');
    ud.bound_typectrl= xreguicontrol('parent',fig,...
        'visible','off',...
        'style','popupmenu',...
        'string',{'<=', '>='},...
        'backgroundcolor',[1 1 1]);
    ud.seltext=xreguicontrol('parent',fig,...
        'hittest','off',...
        'enable','inactive',...
        'visible','off',...
        'style','text',...
        'string','Selected model:',...
        'horizontalalignment','left');
    txt3=xreguicontrol('parent',fig,...
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
    txt4=xreguicontrol('parent',fig,...
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
        'dimension',[8 10],...
        'colsizes',[200 0 0 40 60 30 0 2 0 165],...
        'rowsizes',[15 20 0 0 15 20 -1 15],...
        'border',[0 0 0 5],...
        'gapx', 5, ...
        'gapy', 5, ...
        'mergeblock',{[2 7],[1 1]}, ...
        'mergeblock',{[1 1],[4 6]}, ...
        'mergeblock',{[5 5],[4 6]}, ...
        'mergeblock',{[6 6],[4 6]}, ...
        'mergeblock',{[8 8],[1 5]}, ...
        'mergeblock',{[2 8],[10 10]}, ...
        'mergeblock',{[1 8],[8 8]}, ...
        'elements',{txt, ud.modptrctrl, [], [], [], [], [], ud.seltext, ...
            [], [], [], [], [], [], [], [], ...
            [], [], [], [], [], [], [], [], ...
            txt2, ud.bound_typectrl, [], [], txt3, ud.datasetsctrl, [], [], ...
            [], ud.boundctrl, [], [], [], [], [], [], ...
            [], [], [], [], [], [], [], [], ...
            [], [], [], [], [], [], [], [], ...
            div, [], [], [], [], [], [], [], ...
            [], [], [], [], [], [], [], [], ...
            txt4, ud.weightsctrl},...
        'userdata', infoptr);
    i_setuplayout(infoptr);
    i_selmodel(ud.modptrctrl, [], infoptr);
end


function i_setuplayout(udh)
ud = udh.info;
P = getparams(ud.ptr.info);

modelnames = pveceval(ud.modptrs, 'getname');
if ~isempty(P.modptr)
    modelindex = find(P.modptr==ud.modptrs);
else
    modelindex = 1;
end
set(ud.modptrctrl, 'string', modelnames, ...
    'value', modelindex);

dsnames = pveceval(ud.oppointptrs, 'getname');
if ~isempty(P.oppoint)
    dsindex = find(P.oppoint==ud.oppointptrs);
else
    dsindex = 1;
end
set(ud.datasetsctrl, 'string', dsnames, ...
    'value', dsindex);

Npts = ud.oppointptrs(dsindex).get('numpoints');
if length(P.weights) ~= Npts
    P.weights =  ones(Npts, 1);
end
set(ud.bound_typectrl, 'value', P.bound_type+1);
set(ud.boundctrl, 'value', P.bound);
set(ud.weightsctrl, 'vector', P.weights, 'DataSet', ud.oppointptrs(dsindex));



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
    modelindex  = get(ud.modptrctrl, 'value');
    dsindex = get(ud.datasetsctrl, 'value');
    bound = get(ud.boundctrl, 'value');
    bound_type = get(ud.bound_typectrl, 'value')-1;
    weights = get(ud.weightsctrl, 'vector');
    [c,msg]=setparams(ud.ptr.info,'modptr', ud.modptrs(modelindex), ...
        'bound', bound, ...
        'bound_type', bound_type,...
        'oppoint', ud.oppointptrs(dsindex), ...
        'weights', weights);
    ud.ptr.info=c;
else
    msg = {'You must have a dataset and a model for a sum constraint'};
end
ok= isempty(msg);