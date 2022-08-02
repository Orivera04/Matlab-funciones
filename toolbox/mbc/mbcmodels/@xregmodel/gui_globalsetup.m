function [mout,ok] = gui_globalsetup(m,action,varargin)
%GUI_GLOBALSETUP Set up global model options
%
%   [M,OK]=GUI_GLOBALSETUP(M) creates a modal,blocking dialog for editing
%   the global model type and options of the model M.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.4.4 $  $Date: 2004/04/04 03:30:20 $

if nargin<2
    action='figure';
end

switch lower(action)
    case 'figure'
        [mout,ok] = i_createfig(m,varargin{:});
    case 'layout'
        % currently unsupported
end



function [mout,ok] = i_createfig(m,varargin)
scr = get(0,'screensize');
if any(strcmp('global',varargin));
    nm = 'Global Model Setup';
else
    nm = 'Model Setup';
end

figh = xregdialog('name',nm,...
    'position',[scr(3)*.5-250 scr(4)*.5-175 510 400],...
    'resize','off');

p = xregGui.RunTimePointer(m);
p.LinkToObject(figh);
lyt = i_createlyt(figh,p,varargin{:});

% add ok, cancel
okbtn = uicontrol('style','pushbutton',...
    'parent',figh,...
    'string','OK',...
    'callback','set(gcbf,''tag'',''ok'', ''visible'', ''off'');');
cancbtn = uicontrol('style','pushbutton',...
    'parent',figh,...
    'string','Cancel',...
    'callback','set(gcbf, ''tag'',''cancel'', ''visible'', ''off'');');
helpbtn = mv_helpbutton(figh,'xreg_globalModelSetup');

ud.brd = xreggridbaglayout(figh, 'dimension',[2 4], ...
    'rowsizes',[-1 25], ...
    'border',[7 7 7 10], ...
    'colsizes', [-1 65 65 65], ...
    'gapx', 7, ...
    'gapy', 10, ...
    'mergeblock', {[1 1], [1 4]}, ...
    'elements',{lyt,[], [],okbtn, [],cancbtn, [],helpbtn});
ud.figure=figh;

figh.LayoutManager = ud.brd;
set(ud.brd, 'packstatus', 'on');
set(lyt,'visible','on');

set(figh,'userdata',ud);
figh.showDialog(okbtn);

tg = get(figh,'tag');
if strcmp(tg, 'ok')
    pUD = get(lyt, 'userdata');
    ud = pUD.info;
    cls = gui_globalmodsetup(p.info,'getclasslevel');
    val = strmatch(cls,ud.classfuncs);
    lyt = getcard(ud.cards,val);
    lyt = lyt{1};
    % Call finalise on chosen class
    mout = gui_globalmodsetup(p.info, 'finalise', lyt, p);
    ok = 1;
else
    mout = m;
    ok = 0;
end
delete(figh);



%------------------------------------------------------------
%   SUBFUNCTION     i_createlyt
%------------------------------------------------------------
function lyt = i_createlyt(figh,p,varargin)

if ~isa(figh,'xregcontainer')
    crit = 0; %(all)
    % parse out varargin
    if nargin>2
        for n= 1:2:length(varargin)
            switch lower(varargin{n})
                case 'criteria'
                    crit = strmatch(varargin{n+1},{'all','linear','non-linear','','global'})-1;
            end
        end
    end
    % list of model classes
    pUD = xregGui.RunTimePointer;
    pUD.LinkToObject(figh);
    ud = ModelClasses(p.info,crit);
    ud.pointer = p;
    ud.figure = figh;

    SC = xregGui.SystemColorsDbl;
    ud.class = uicontrol('parent',figh,...
        'style','popupmenu',...
        'string',ud.classnames,...
        'interruptible','off', ...
        'backgroundcolor', SC.WINDOW_BG, ...
        'callback', {@i_classchng,pUD});
    classtxt = xregGui.labelcontrol('Parent', figh, ...
        'string', 'Model class:', ...
        'LabelSizeMode', 'absolute', ...
        'LabelSize', 70, ...
        'Gap', 0, ...
        'ControlSize', 150, ...
        'Control', ud.class);
    
    divl = xregGui.dividerline(figh,'orientation','horizontal');
    crd = xregcardlayout(figh,'numcards',length(ud.classfuncs));
    lyt = xreggridbaglayout(figh, ...
        'dimension',[3 1],...
        'rowsizes',[20 20 -1], ...
        'elements',{classtxt,divl,crd}, ...
        'userdata', pUD);
    ud.cardsdone = false(1,length(ud.classfuncs));
    ud.cards = crd;
    
else
    pUD = get(figh, 'userdata');
    ud = pUD.info;
end

ud=i_setvalues(ud);
pUD.info = ud;



%------------------------------------------------------------
%   SUBFUNCTION     i_setvalues
%------------------------------------------------------------
function ud = i_setvalues(ud)
% Decide which card to show
% Ask the gui_globalmodsetup which level it is operating at
cls = gui_globalmodsetup(ud.pointer.info,'getclasslevel');
val = strmatch(cls,ud.classfuncs);
set(ud.class,'value',val);
if ~ud.cardsdone(val)
    % need to create card
    lyt = gui_globalmodsetup(ud.pointer.info,'layout',ud.figure,ud.pointer);
    attach(ud.cards,lyt,val);
    ud.cardsdone(val) = true;
else
    % update existing layout
    lyt = getcard(ud.cards,val);
    lyt = lyt{1};
    gui_globalmodsetup(ud.pointer.info,'layout',lyt,ud.pointer);
end
set(ud.cards,'currentcard',val);



%------------------------------------------------------------
%   SUBFUNCTION     i_classchng
%------------------------------------------------------------
function i_classchng(src, evt, pUD)
ud = pUD.info;
val = get(ud.class,'value');
if val~=get(ud.cards,'currentcard')
    set(ud.figure,'pointer','watch');
    %change needed
    m = ud.pointer.info;
    % try to create new model class
    try
        mnew = feval(ud.createclassfuncs{val},'nfactors',nfactors(m));
    catch
        e = lasterror;
        % Strip off initial line of error that contains "Error using ..."
        dispstr = regexprep(e.message, sprintf('Error using.*\n'), '');
        
        fig = errordlg(['Error creating model.  ' dispstr], ...
            'Model Creation Error', 'modal');
        waitfor(fig);
        % return to previous setting
        val = strmatch(class(m),ud.classfuncs);
        if isempty(val)
            brk = false;
            val = 0;
            while ~brk && val<=length(ud.classfuncs)
                val = val+1;
                if isa(m,ud.classfuncs{val})
                    brk = true;
                end
            end
            if val<1 || val>length(ud.classfuncs)
                val = 1;
            end
        end
        set(ud.class,'value',val);
        set(ud.figure,'pointer','arrow');
        return
    end
    mnew = copymodel(m, mnew);
    ud.pointer.info = mnew;

    % update options space
    if ~ud.cardsdone(val)
        % need to create card
        set(ud.cards, 'packstatus', 'off');
        lyt = gui_globalmodsetup(mnew,'layout',ud.figure,ud.pointer);
        attach(ud.cards,lyt,val);
        ud.cardsdone(val) = 1;
    else
        % update existing layout
        lyt = getcard(ud.cards,val);
        lyt = lyt{1};
        gui_globalmodsetup(mnew,'layout',lyt,ud.pointer);
    end
    set(ud.cards,'packstatus','on', 'currentcard',val);
    pUD.info = ud;
    set(ud.figure,'pointer','arrow');
end
