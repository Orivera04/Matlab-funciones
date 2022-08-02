function [mout,ok]=gui_globalmodsetup(m,action,varargin);
%GUI_GLOBALMODSETUP  GUI for altering xreglinear settings
%
%  [M,OK]=GUI_GLOBALMODSETUP(M) creates a blocking GUI for choosing the
%  subclass of linearmodel and altering its settings.  OK indicates
%  whether the user pressed 'OK' or 'Cancel'.
%
%  LYT=GUI_GLOBALMODSETUP(M,'layout',FIG,P) creates a layout in figure
%  FIG, using the dynamic copy of a model in P.
%
%  LYT=GUI_GLOBALMODSETUP(M,'layout',FIG,P,'callback',CBSTR) attaches a
%  callback string, CBSTR, which is fired when the model definition is
%  changed.  The string may contain the tokens %MODEL% and %POINTER% which
%  will be replaced with the current model and the pointer before the
%  callback is executed.
%
%  lyt=GUI_GLOBALMODSETUP(M,'stepwisecontrol',lyt, str) disables (str =
%  'off') and enables (str = 'on') the stepwise controls

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.4.5 $  $Date: 2004/04/04 03:30:07 $

if nargin<2
    action = 'figure';
end

switch lower(action)
    case 'figure'
        [mout,ok] = i_createfig(m);
    case 'layout'
        mout = i_createlyt(varargin{:});
        ok = 1;
    case 'getclasslevel'
        mout = mfilename('class');
    case 'finalise'
        mout = m;
end



function [mout, ok] = i_createfig(m, varargin)
figh = xregdialog('name','Linear Model Settings');
figh.MinimumSize = [450 290];
xregcenterfigure(figh, [510, 350]);

p = xregGui.RunTimePointer(m);
p.LinkToObject(figh);
lyt = i_createlyt(figh, p, varargin{:});

% Add ok, cancel
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



function lyt = i_createlyt(figh, p, varargin)
if ~isa(figh,'xregcontainer')
    pUD = xregGui.RunTimePointer;
    pUD.LinkToObject(figh);
    
    ud.callback = '';
    ud.ShowStepwise = true;
    if nargin>2
        for n = 1:2:length(varargin)
            switch lower(varargin{n})
                case 'callback'
                    ud.callback = varargin{n+1};
                case 'stepwise'
                    ud.ShowStepwise = varargin{n+1};
            end
        end
    end

    ud.pointer = p;
    ud.figure = figh;
    m = p.info;
    ud.termsel = [];
    ud.termselfig = [];
    ud.termselmade = false;
    ud.popval = [];
    ud.classfuncs = {'xregcubic','xreg3xspline'};
    for n = 1:length(ud.classfuncs);
        if isa(m,ud.classfuncs{n})
            ud.popval = n;
            break
        end
    end
    if isempty(ud.popval)
        close(figh);
        error('mbc:xreglinear:InvalidArgument', ...
            'Model must be an xregcubic or an xreg3xspline.' );
    end
    
    SC = xregGui.SystemColorsDbl;
    
    % This level controls a popup menu and term selection controls
    ud.popup = xreguicontrol('style','popupmenu',...
        'parent',figh,...
        'backgroundcolor', SC.WINDOW_BG,...
        'string',{'Polynomial','Hybrid spline'},...
        'value',ud.popval,...
        'interruptible','off',...
        'visible','off', ...
        'callback',{@i_classchange, pUD});
    classLabel = xregGui.labelcontrol('Parent', figh, ...
        'visible', 'off', ...
        'String', 'Linear model subclass:', ...
        'ControlSize', 150, ...
        'LabelSize', 120, ...
        'LabelSizeMode', 'absolute', ...
        'Gap', 5, ...
        'Control', ud.popup);

    ud.ntermsinfo = xreggridbaglayout(figh, ...
        'packstatus', 'off', ...
        'vscroll', 'on', ...
        'slidersize', 15, ...
        'dimension', [0 3], ...
        'colsizes', [-1 30 2]);
    ud.termsedt = xreguicontrol('parent',figh,...
        'style','pushbutton',...
        'string','Edit Terms...',...
        'visible','off',...
        'callback',{@i_termeditor, pUD},...
        'interruptible','off');
    
    if ud.ShowStepwise
        ud.StepOptions = {'None','Minimize PRESS','Forward selection', ...
            'Backward selection','Prune'};
        ud.StepFuncs = {'leastsq', @minpress, @forwardselect, ...
            @backwardselect, @prune};
        ud.FitOptions = xreguicontrol('style','popupmenu',...
            'parent',figh,...
            'backgroundcolor',SC.WINDOW_BG,...
            'string',ud.StepOptions,...
            'callback',{@i_setStepwise, pUD},...
            'interruptible','off',...
            'visible','off');  
        stepLabel = xregGui.labelcontrol('Parent', figh, ...
            'visible', 'off', ...
            'String', 'Stepwise:', ...
            'ControlSize', 1, ...
            'ControlSizeMode', 'relative', ...
            'LabelSize', 50, ...
            'LabelSizeMode', 'absolute', ...
            'Gap', 5, ...           
            'Control', ud.FitOptions);
        ud.FitOptsButton = xreguicontrol('style','pushbutton',...
            'parent',figh,...
            'string','Options...',...
            'callback',{@i_setFitOpts, pUD},...
            'visible','off');
        div = xregGui.dividerline('Parent', figh, ...
            'Visible', 'off');
        ud.StepLayout = xreggridbaglayout(figh, ...
            'dimension', [3 2], ...
            'rowsizes', [2 20 25], ...
            'gapy', 5, ...
            'colsizes', [-1 75], ...
            'mergeblock', {[1 1], [1 2]}, ...
            'mergeblock', {[2 2], [1 2]}, ...
            'elements', {div, stepLabel, [], [], [], ud.FitOptsButton});
        StepwiseHeight = 57;
        StepwiseGap = 5;
    else
        ud.StepOptions = {};
        ud.stepFuncs = {};
        ud.FitOptions = [];
        ud.FitOptsButton = [];
        ud.StepLayout = [];
        StepwiseHeight = 0;
        StepwiseGap = 0;
    end
    
    % Create model specific layout
    innerlyt = gui_globalmodpane(m,'layout',figh,p, ...
        'callback', {@i_modelupdate, pUD});
    ud.layoutsdone = false(1,length(ud.classfuncs));
    ud.layoutsdone(ud.popval) = true;
    ud.layers = xregcardlayout(figh,'numcards',length(ud.classfuncs), ...
        'visible', 'off', ...
        'currentcard', ud.popval);
    attach(ud.layers, innerlyt, ud.popval);

    termsGrid = xreggridbaglayout(figh, ...
        'dimension', [5 2], ...
        'rowsizes', [-1 5 25 StepwiseGap StepwiseHeight], ...
        'colsizes', [-1 75], ...
        'mergeblock', {[1 1], [1 2]}, ...
        'mergeblock', {[5 5], [1 2]}, ...
        'elements', {ud.ntermsinfo, [], [], [], ud.StepLayout, [], [], ud.termsedt});
    ttl = xregframetitlelayout(figh, ...
        'visible', 'off', ...
        'center',ud.layers, ...
        'title','Model options');
    ttl2 = xregframetitlelayout(figh, ...
        'visible', 'off', ...
        'center',termsGrid, ...
        'title','Model terms',...
        'innerborder',[20 10 10 10]);
    lyt = xreggridbaglayout(figh, ...
        'dimension', [2 2], ...
        'rowsizes', [20 -1], ...
        'colsizes', [-1 210], ...
        'gapx', 10, ...
        'gapy', 10, ...
        'mergeblock', {[1 1], [1 2]}, ...
        'elements', {classLabel, ttl, [], ttl2}, ...
        'userdata', pUD);
else
    lyt = figh;
    pUD = get(lyt, 'userdata');
    ud = pUD.info;
    
    % Update with new pointer
    ud.pointer = p;
    val = find(strcmp(class(p.info),ud.classfuncs));
    if val~=ud.popval
        % Need to alter viewed sub-pane
        if ~ud.layoutsdone(val)
            % create
            attach(ud.layers, gui_globalmodpane(p.info,'layout',figh, ...
                ud.pointer,'callback',{@i_modelupdate, pUD}), ...
                val);
            ud.layoutsdone(val) = true;
            set(ud.layers,'packstatus','on');
        else
            % re-show
            sublyt = getcard(ud.layers,val);
            gui_globalmodpane(p.info, 'layout', sublyt{1}, ud.pointer);
        end
        set(ud.layers,'currentcard',val);
        set(ud.popup,'value',val);
        ud.popval = val;
    else
        % re-show
        sublyt = getcard(ud.layers,val);
        gui_globalmodpane(p.info, 'layout', sublyt{1}, ud.pointer);
    end
end
pUD.info = ud;
i_termsinfo(ud);



function  i_termeditor(h,evt,pUD)
% Pop open a term editing window
ud = pUD.info;
PR = xregGui.PointerRepository;
figh = ud.figure;
ptrID = PR.stackSetPointer(figh,'watch');

if ~ud.termselmade
    scr = get(0,'screensize');
    h = xregdialog('Name','Term Editor',...
        'resize','off');
    xregcenterfigure(h, [202 350]);
    set(h,'userdata',handle.listener(figh,'ObjectBeingDestroyed',{@i_delete,h}));

    ud.termsel = term_selector(h, ...
        'frame.visible','off',...
        'frame.vborder',[0 0], ...
        'frame.hborder',[0 0]);
    updatecommand(ud.termsel,@i_termschange,{pUD,'%MODEL'});
    clsbut = uicontrol('parent',h,...
        'string','Close',...
        'style','pushbutton',...
        'callback','set(gcbf,''visible'',''off'');');
    p = xregpanellayout(h, ...
        'innerborder',[0 0 0 0], ...
        'packstatus','off', ...
        'center',ud.termsel);
    grd = xreggridbaglayout(h, ...
        'dimension',[2 3],....
        'rowsizes',[-1 25],...
        'colsizes',[-1 65 7],...
        'gapy',7,...
        'border',[0 7 0 0],...
        'mergeblock',{[1 1],[1 3]},...
        'elements',{p,[],[],clsbut});
    h.LayoutManager = grd;
    set(grd,'packstatus','on');

    ud.termselfig = h;
    ud.termselmade = true;
end
pUD.info = ud;

model(ud.termsel,ud.pointer.info);
ud.termselfig.showDialog;
PR.stackRemovePointer(figh,ptrID);

function i_delete(src,evt,h)
delete(h);

function i_termschange(pUD,m)
% return function for term editing window
ud = pUD.info;
ud.pointer.info = m;
i_termsinfo(ud);
i_firecb(ud.callback,ud.pointer);


function  i_modelupdate(m, evt, pUD)
% update term info due to changes in options pane
ud = pUD.info;
PR = xregGui.PointerRepository;
figh = ud.figure;
ptrID = PR.stackSetPointer(figh,'watch');
i_termsinfo(ud);
if ~isempty(ud.callback)
    i_firecb(ud.callback,ud.pointer);
end
PR.stackRemovePointer(figh,ptrID);


function i_classchange(h, evt, pUD)
% need to create new model, copy parent model class over it
ud = pUD.info;
figh = ud.figure;
PR = xregGui.PointerRepository;
ptrID = PR.stackSetPointer(figh,'watch');

val = get(ud.popup,'value');
oldm = ud.pointer.info;
nf = nfactors(oldm);
newm = feval(ud.classfuncs{val},'nfactors',nf);
newm = copymodel(oldm,newm);
ud.pointer.info = newm;

% update term_selector
i_termsinfo(ud);

% update model dependent_pane
if ~ud.layoutsdone(val)
    % create
    attach(ud.layers,gui_globalmodpane(newm,'layout',figh,ud.pointer, ...
        'callback', {@i_modelupdate, pUD}),val);
    ud.layoutsdone(val) = true;
    set(ud.layers,'packstatus','on');
else
    % re-show
    lyt = getcard(ud.layers,val);
    gui_globalmodpane(newm,'layout',lyt{1},ud.pointer);
end
% flick cards
set(ud.layers,'currentcard',val);
ud.popval = val;
pUD.info = ud;
if ~isempty(ud.callback)
    i_firecb(ud.callback,ud.pointer);
end
PR.stackRemovePointer(figh,ptrID);


function val = i_stepwise(ud)
m = ud.pointer.info;
om = getFitOpt(m);
if ischar(om) && strcmp(om,'leastsq');
    % No stepwise
    val = 1;
else
    nm = getname(om);
    AllOpts = get(ud.FitOptions,'string');
    val =  strmatch(nm(1:3),AllOpts) ;
end


function i_setStepwise(h, evt, pUD);
ud = pUD.info;
m = ud.pointer.info;
opt = get(ud.FitOptions,'value');
if i_stepwise(ud)~=opt
    if opt==1
        om = 'leastsq';
        set(ud.FitOptsButton,'enable','off');
    else
        om = feval(ud.StepFuncs{opt}, m);
        set(ud.FitOptsButton,'enable','on');
    end
    m = setFitOpt(m,om);
    ud.pointer.info = m;
    i_firecb(ud.callback,ud.pointer);
end


function i_setFitOpts(h, evt, pUD)
ud = pUD.info;
m = ud.pointer.info;
om = getFitOpt(m);
[om,ok] = gui_setup(om,'figure');
if ok
    m = setFitOpt(m,om);
    ud.pointer.info = m;
    i_firecb(ud.callback, ud.pointer);
end


% Update the information in the Terms frame
function i_termsinfo(ud)
if ud.ShowStepwise
    stepval = i_stepwise(ud);
    set(ud.FitOptions, 'value', stepval);
    if stepval==1
        set(ud.FitOptsButton, 'enable', 'off');
    else
        set(ud.FitOptsButton, 'enable', 'on');
    end
end

% update the info on the number of terms
[tind,trmsorder,strs] = termorder(ud.pointer.info);
trms = cumsum(terms2(ud.pointer.info));

el = get(ud.ntermsinfo,'elements');
el = [el{:}];
nr = length(trmsorder)+1;
nreq = (nr)*2;
if length(el)<nreq
    % make more controls
    set(el,'visible','off');
    for n = (length(el)+1):nreq
        el(n) = xreguicontrol('parent',ud.figure, ...
            'enable', 'inactive', ...
            'style','text',...
            'visible','off');
    end
elseif length(el)>nreq
    % delete some controls
    delete(el((nreq+1):end));
    el = el(1:nreq);
    set(el,'visible','off');
end

set(el(1:nr-1),{'string'},strs(:), ...
    'horizontalalignment','left', ...
    'fontweight','normal');
set(el(nr),'string','Total number of terms:', ...
    'horizontalalignment','left',...
    'fontweight','bold');
vals = [trms(trmsorder(1)); diff(trms(cumsum(trmsorder)))];
set(el(nr+1:end-1),{'string'},num2cell(vals(:),2), ...
    'horizontalalignment','right', ...
    'fontweight','normal');
set(el(end),'string',trms(end), ...
    'horizontalalignment','right', ...
    'fontweight','bold');

el = num2cell(el(:),2);

set(ud.ntermsinfo,'dimension',[nr+1 3],...
    'gap',5, ...
    'rowsizes',[repmat(15,1,nr-1) 5 15],...
    'elements',[el(1:nr-1); {[]}; el(nr:end-1); {[]}; el(end)]);


function i_firecb(cbstr,ptr)
% parse callback string and execute it
if ~isempty(cbstr)
    % parse for %MODEL% and %POINTER% 
    if ischar(cbstr)
        pcs=findstr(cbstr,'%');
        go=1;
        needobj=0;
        needval=0;
        while (go<=(length(pcs)-1))
            cmp=cbstr(pcs(go)+1:pcs(go+1)-1);
            if strcmp(cmp,'POINTER')
                needval=1;
                cbstr=[cbstr(1:pcs(go)-1) 'XX_POINTER_XX' cbstr(pcs(go+1)+1:end)];
                go=go+2;
                pcs=pcs+6;
            elseif strcmp(cmp,'MODEL')
                needobj=1;
                cbstr=[cbstr(1:pcs(go)-1) 'XX_MODEL_XX' cbstr(pcs(go+1)+1:end)];
                go=go+2;
                pcs=pcs+6;
            else
                go=go+1;
            end
        end

        if needobj
            assignin('base','XX_MODEL_XX',ptr.info);
        end
        if needval
            assignin('base','XX_POINTER_XX',ptr);
        end
        evalin('base',cbstr);
        
        % clear up base workspace
        evalin('base','clear(''XX_MODEL_XX'',''XX_POINTER_XX'');');
    else
        xregcallback(cbstr, [] , struct('ModelPointer', ptr));
    end
end
