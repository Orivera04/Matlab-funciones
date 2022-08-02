function [m,ok]=gui_globalmodsetup(m,action,varargin);
%GUI_GLOBALMODSETUP  GUI for altering xregmulti settings
%
%  [M,OK]=GUI_GLOBALMODSETUP(M) creates a blocking GUI for choosing the
%  subclass of linearmodel and altering its settings.  OK indicates whether
%  the user pressed 'OK' or 'Cancel'.
%
%  LYT=GUI_GLOBALMODSETUP(M,'layout',FIG,P) creates a layout in figure FIG,
%  using the dynamic copy of a model in P.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.4.4 $  $Date: 2004/04/04 03:30:27 $

if nargin<2
    action='figure';
end

switch lower(action)
    case 'figure'
        [m,ok]=i_createfig(m, varargin{:});
    case 'layout'
        ok=1;
        m=i_createlyt(varargin{:});
    case 'getclasslevel'
        m=mfilename('class');
end




function [mout,ok]=i_createfig(m, varargin)
scr = get(0,'screensize');
figh = xregdialog('name','Multi-Model Settings',...
    'position',[scr(3)*.5-125 scr(4)*.5-60 510 350],...
    'resize','off');

p = xregGui.RunTimePointer(m);
p.LinkToObject(figh);
lyt = i_createlyt(figh, p, varargin{:});

% add ok, cancel
okbtn = uicontrol('style','pushbutton',...
    'parent',figh,...
    'string','OK',...
    'callback','set(gcbf,''visible'', ''off'', ''tag'',''ok'');');
cancbtn = uicontrol('style','pushbutton',...
    'parent',figh,...
    'string','Cancel',...
    'callback','set(gcbf,''visible'', ''off'', ''tag'',''cancel'');');

lyt = xreggridbaglayout(figh, ...
    'packstatus', 'off', ...
    'dimension', [2 3], ...
    'rowsizes', [-1 25], ...
    'colsizes', [-1 65 65], ...
    'gapx', 7, ...
    'gapy', 7, ...
    'border', [7 7 7 10], ...
    'mergeblock', {[1 1], [1 3]}, ...
    'elements', {lyt, [], [], okbtn, [], cancbtn});

figh.LayoutManager = lyt;
set(lyt, 'packstatus', 'on', 'visible', 'on');
figh.showDialog(okbtn);

tg = get(figh,'tag');
if strcmp(tg, 'ok')
    mout = p.info;
    ok = 1;
else
    mout = m;
    ok = 0;
end
delete(figh);



function lyt = i_createlyt(figh,p, varargin)

if ~isa(figh,'xregcontainer')
    % Parse out optional arguments
    ud.ModelEditFcn = @gui_globalsetup;
    ud.EditWeights = true;
    for n = 1:2:length(varargin)
        switch lower(varargin{n})
            case 'modeleditfcn'
                ud.ModelEditFcn = varargin{n+1};
            case 'allowweightediting'
                ud.EditWeights = varargin{n+1};
        end
    end
    ud.pointer=p;
    ud.figure=figh;

    ud.add = uicontrol('parent',figh,...
        'style','pushbutton',...
        'visible','off',...
        'position',[0 0 80 25],...
        'string','Add...');
    ud.editmod = uicontrol('parent',figh,...
        'style','pushbutton',...
        'visible','off',...
        'position',[0 0 80 25],...
        'string','Edit Model...');
    ud.delete = uicontrol('parent',figh,...
        'style','pushbutton',...
        'visible','off',...
        'position',[0 0 80 25],...
        'string','Delete');
    ud.list = uicontrol('parent',figh,...
        'style','listbox',...
        'visible','off',...
        'backgroundcolor','w');

    ud.weighttxt = uicontrol('parent',figh,...
        'style','text',...
        'visible','off',...
        'horizontalalignment','left',...
        'string','Weighting factor for ',...
        'position',[0 0 300 30]);
    ud.weightedt = xregGui.clickedit(figh,...
        'visible','off',...
        'min',0,...
        'max',1,...
        'dragincrement',.05,...
        'clickincrement',.1);
    ud.primetxt = uicontrol('parent',figh,...
        'style','text',...
        'visible','off',...
        'horizontalalignment','left',...
        'string','Primary model: ',...
        'position',[0 0 300 30]);
    ud.primepush = uicontrol('parent',figh,...
        'style','pushbutton',...
        'visible','off',...
        'position',[0 0 85 25],...
        'string','Use Selected');

    udh=ud.primetxt;

    % callbacks
    set(ud.list,'callback',{@i_modelsel, udh});
    set(ud.add,'callback',{@i_add, udh});
    set(ud.editmod,'callback',{@i_edit, udh});
    set(ud.delete,'callback',{@i_deletemodel, udh});
    set(ud.weightedt,'callback',{@i_weightchng, udh});
    set(ud.primepush,'callback',{@i_selectmodel, udh});

    % layouts
    flw=xregflowlayout(figh,'packstatus','off',...
        'orientation','top/right','gap',10,...
        'border',[0 0 0 -10],'elements',{ud.add,ud.editmod,ud.delete});
    brd1=xregborderlayout(figh,'center',ud.list,'east',flw,...
        'innerborder',[0 0 100 0]);
    flw2=xregflowlayout(figh,'orientation','left/center',...
        'elements',{ud.weighttxt,ud.weightedt},'gap',10,'border',[-10 0 0 0]);
    flw3=xregflowlayout(figh,'orientation','left/center',...
        'elements',{ud.primetxt,ud.primepush},'gap',10,'border',[-10 0 0 0]);
    grd=xreggridlayout(figh,'correctalg','on','dimension',[2 1],...
        'elements',{flw2,flw3});

    top=xregframetitlelayout(figh,'title','Models','visible','off',...
        'center',brd1,'border',[0 5 0 0]);
    btm=xregframetitlelayout(figh,'title','Options','visible','off',...
        'center',grd,'border',[0 0 0 5]);
    lyt=xregborderlayout(figh,'center',top,'south',btm,...
        'innerborder',[0 100 0 0]);
else
    lyt=figh;
    el=get(get(get(lyt,'south'),'center'),'elements');
    el=get(el{2},'elements');
    el=el{1};
    ud=get(el,'userdata');
    ud.pointer=p;
    figh=ud.figure;

end

ud=i_setvalues(ud);
set(ud.primetxt,'userdata',ud);




function ud=i_setvalues(ud)

m=ud.pointer.info;
% populate listbox with model descriptions
mdls = get(m,'models');
ud.weights = get(m,'weights');
nmdls=length(mdls);
str=cell(nmdls,1);
for n=1:nmdls;
    str(n)={sprintf(['(%d)  ' str_func(mdls{n},0)],n)};
end
% save base model strings for faster updating after a weight change
ud.strs = str;

if ud.EditWeights
    % add weights
    for n=1:nmdls
        str(n) = {[str{n} sprintf('    Weight: %.3f',ud.weights(n))]};
    end

    % set primary model text
    set(ud.primetxt,'string',['Primary model:' char(10) ud.strs{get(m,'currentindex')}]);

    % set weight text and weight value
    set(ud.weighttxt,'string',['Weighting factor for model: ' char(10) ud.strs{1} ' :']);
    set(ud.weightedt,'value',ud.weights(1));

end
set(ud.list,'string',str,'value',1);

% set enable status of delete button
if nmdls==1
    set(ud.delete,'enable','off');
end




function i_weightchng(srcobj,evt,udh)
ud=get(udh,'userdata');
val=get(ud.weightedt, 'value');

selval=get(ud.list,'value');
nmdls=length(ud.weights);
if nmdls==1
    % can't change weight!
    set(ud.weightedt,'value',1);
else
    inds=1:nmdls;
    inds(selval)=[];
    ud.weights(selval) = val;

    m=ud.pointer.info;
    m = set(m,'weights',ud.weights);
    % get sorted out weights
    %ud.weights = get(m,'weights');

    str=get(ud.list,'string');
    % Alter list box
    str(selval) = {[ud.strs{selval} sprintf('    Weight: %.3f',ud.weights(selval))]};
    set(ud.list,'string',str);

    ud.pointer.info = m;
    set(udh,'userdata',ud);
end


function i_modelsel(srcobj,evt,udh)
ud = get(udh,'userdata');
selval=get(ud.list,'value');
if ud.EditWeights
    % update weight text
    set(ud.weighttxt,'string',['Weighting factor for model:' char(10) ud.strs{selval} ' :']);
    set(ud.weightedt,'value',ud.weights(selval));
end

function i_selectmodel(srcobj,evt,udh)
ud=get(udh,'userdata');
selval=get(ud.list,'value');
m=ud.pointer.info;
set(m,'currentindex',selval);
if ud.EditWeights
    set(ud.primetxt,'string',['Primary model: ' char(10) ud.strs{selval}]);
end
ud.pointer.info=m;


function i_deletemodel(srcobj,evt,udh)
ud=get(udh,'userdata');
selval=get(ud.list,'value');

ud.strs(selval)=[];
m=ud.pointer.info;
m=remove(m,selval);
if ud.EditWeights
    ud.weights = get(m,'weights');
end
% rebuild listbox string
mdls=get(m,'models');
nmdls=length(mdls);
str=cell(nmdls,1);
for n=1:nmdls;
    str(n)={sprintf(['(%d)  ' str_func(mdls{n},0)],n)};
end
ud.strs=str;
if ud.EditWeights
    % Alter list box
    for i=1:length(ud.weights)
        str(i) = {[str{i} sprintf('    Weight: %.3f',ud.weights(i))]};
    end
end
if selval>length(str)
    newselval=length(str);
else
    newselval=selval;
end
set(ud.list,'string',str,'value',newselval);

if ud.EditWeights
    % alter weight
    set(ud.weighttxt,'string',['Weighting factor for model:' char(10) ud.strs{newselval} ' :']);
    set(ud.weightedt,'value',ud.weights(newselval));

    % alter primary
    prime=get(m,'currentindex');
    set(ud.primetxt,'string',['Primary model: ' char(10) ud.strs{prime}]);
end

% check enable status of delete
if length(ud.weights)==1
    set(ud.delete,'enable','off');
end

set(udh,'userdata',ud);
ud.pointer.info=m;


function i_add(srcobj,evt,udh)
ud=get(udh,'userdata');
set(ud.figure,'pointer','watch');
m=ud.pointer.info;

% add a default model
m=add(m);
mdls=get(m,'models');

[newm,ok] = feval(ud.ModelEditFcn, mdls{end});

if ok
    mdls(end)={newm};
    set(m,'models',mdls);
    ud.strs(end+1)={sprintf(['(%d)  ' str_func(mdls{end},0)],length(mdls))};
    str=ud.strs;
    if ud.EditWeights
        ud.weights = get(m,'weights');
        
        % Alter list box
        for i=1:length(mdls)
            str(i) = {[str{i} sprintf('    Weight: %.3f',ud.weights(i))]};
        end
    end
    set(ud.list,'string',str);

    if ud.EditWeights
        % reset weight box
        selval=get(ud.list,'value');
        set(ud.weightedt,'value',ud.weights(selval));
    end
    
    % enable delete
    set(ud.delete,'enable','on');

    ud.pointer.info=m;
    set(udh,'userdata',ud);
end
set(ud.figure,'pointer','arrow');


function i_edit(srcobj,evt,udh)
ud=get(udh,'userdata');
set(ud.figure,'pointer','watch');
selval=get(ud.list,'value');
m=ud.pointer.info;
mdls = get(m,'models');

[newm,ok] = feval(ud.ModelEditFcn, mdls{selval});

if ok
    mdls(selval)={newm};
    set(m,'models',mdls);
    ud.strs(selval)={sprintf(['(%d)  ' str_func(mdls{selval},0)],selval)};
    str=get(ud.list,'string');
    if ud.EditWeights
        str(selval) = {[ud.strs{selval} sprintf('    Weight: %.3f',ud.weights(selval))]};
        set(ud.weighttxt,'string',['Weighting factor for model:' char(10) ud.strs{selval} ' :']);
        if selval==get(m,'currentindex')
            set(ud.primetxt,'string',['Primary model: ' char(10) ud.strs{selval}]);
        end
    else
        str(selval) = ud.strs(selval);
    end
    set(ud.list,'string',str);
    
    ud.pointer.info=m;
    set(udh,'userdata',ud);
end
set(ud.figure,'pointer','arrow');
