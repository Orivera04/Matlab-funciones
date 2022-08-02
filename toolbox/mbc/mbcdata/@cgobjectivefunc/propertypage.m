function [out,out2]=propertypage(obj,action,varargin)
%PROPERTYPAGE   Generate an editing page for this constraint
%
%  LYT=PROPERTYPAGE(OBJ,'CREATE',FIG,PTR,OPTIM, PPROJECT)
%  [OK,MSG]= PROPERTYPAGE(OBJ,'FINALISE',LYT)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.1 $    $Date: 2004/02/09 06:50:28 $

switch lower(action)
    case 'create'
        out=i_createlyt(varargin{:});
        out2=[];
    case 'finalise'
        [out,out2]=i_finalise(varargin{:});
end
return



function lyt=i_createlyt(fig,ptr,optim, pPROJ)

infoptr = xregGui.RunTimePointer;
infoptr.LinkToObject(fig);

% all cage models are listed
nodes = filterbytype(pPROJ.info,cgtypes.cgmodeltype);
modelptrs = null(xregpointer, size(nodes));
for n =1:length(nodes)
    modelptrs(n) = getdata(nodes{n});
end

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
txt2=xreguicontrol('parent',fig,...
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

ud.modptrs = modelptrs;
ud.allowedmods = false(size(modelptrs));
ud.ptr=ptr;
ud.optim = optim;
infoptr.info = ud;


lyt = xreggridbaglayout(fig,...
    'packstatus','off', ...
    'dimension',[4 3],...
    'colsizes',[200 100 -1],...
    'rowsizes',[15 57 -1 15],...
    'border',[0 0 0 5],...
    'gapx', 15, ...
    'gapy', 5, ...
    'mergeblock',{[2 3],[1 1]}, ...
    'mergeblock',{[4 4],[1 2]}, ...
    'elements',{txt, ud.modptrctrl, [], ud.seltext, ...
        txt2, ud.objtype},...
    'userdata', infoptr);

i_setuplayout(infoptr);
i_selmodel(ud.modptrctrl, [], infoptr);
return



function i_setuplayout(infoptr)
ud = infoptr.info;
ObjFunc = ud.ptr.info;

% Set type
minstr = get(ObjFunc, 'minstr');
if ~isempty(minstr)
    typeval = strmatch(minstr, {'min', 'max', 'helper'});
else
    typeval = 1;
end
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


function [ok,msg]=i_finalise(lyt)
infoptr = get(lyt,'userdata');
ud = infoptr.info;

modlist = ud.modptrs(ud.allowedmods);
if ~isempty(modlist)
    modelindex = get(ud.modptrctrl, 'value');
    objtype = get(ud.objtype, 'selected');
    switch objtype
        case 1
            minstr = 'min';
        case 2
            minstr = 'max';
        case 3
            minstr = 'helper';
    end
    ud.ptr.info = set(ud.ptr.info, 'minstr', minstr, 'modptr', modlist(modelindex));
    msg = '';
else
    msg = {'There are no models available for this kind of objective'};
end
delete(infoptr);
ok= isempty(msg);