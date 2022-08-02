function [mout,ok]=gui_globalmodsetup(m,action,varargin)
%GUI_GLOBALMODSETUP GUI for altering RBF model settings
%
%  [M,OK]=GUI_GLOBALMODSETUP(M) creates a blocking GUI for choosing the rbf
%  options and altering its settings.  OK indicates whether the user
%  pressed 'OK' or 'Cancel'.
%
%  LYT = GUI_GLOBALMODSETUP(M,'layout',FIG,P) creates a layout object in
%  the figure FIG which updates the dynamic copy of a model in the pointer
%  P.  Alternatively, if FIG is a handle to a pre-created LYT (using this
%  function) then that layout will be updated with information from the new
%  pointer P.
%
%  LYT = GUI_GLOBALMODSETUP(M,'layout',FIG,P, 'callback',CBSTR) attaches a
%  callback string, CBSTR, which is fired when the model definition is
%  changed.  The string may contain the tokens %MODEL% and %POINTR% which
%  will be replaced with the current model and the pointer before the
%  callback is executed.
%
%  LYT = GUI_GLOBALMODSETUP(M,'layout',FIG,P, 'training',ENABLE) where
%  ENABLE is a boolean flag enables and disables the display of extended
%  training options.  This option may be used in conjunction with the
%  'callback' option above.
%
%  M = GUI_GLOBALMODSETUP(M,'finalise',lyt,p) performs the final operations
%  to save the changes.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.4.5 $  $Date: 2004/04/04 03:30:15 $

if nargin<2
    action='figure';
end

switch lower(action)
    case 'figure'
        [mout,ok] = i_createfig(m);
    case 'layout'
        mout = i_createlyt(varargin{:});
        ok = 1;
    case 'finalise'
        lyt = varargin{1};
        p = varargin{2};
        mout = p.info;
        mout = set(mout, 'fitalg', 'rbffit');
        % update the optim mgr in the model
        pUD = get(lyt, 'userdata');
        ud = pUD.info;
        mout = setFitOpt(mout, ud.ompointer.info);
        ok = 1;
    case 'getclasslevel'
        mout = mfilename('class');
end

return


function [mout,ok] = i_createfig(m, varargin)
figh = xregdialog('name','Radial Basis Function Model Settings',...
    'resize','off');
xregcenterfigure(figh, [500, 350]);

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

mainlyt = xreggridbaglayout(figh, ...
    'packstatus', 'off', ...
    'dimension', [2 3], ...
    'rowsizes', [-1 25], ...
    'colsizes', [-1 65 65], ...
    'gapx', 7, ...
    'gapy', 7, ...
    'border', [7 7 7 10], ...
    'mergeblock', {[1 1], [1 3]}, ...
    'elements', {lyt, [], [], okbtn, [], cancbtn});

figh.LayoutManager = mainlyt;
set(mainlyt, 'packstatus', 'on', 'visible', 'on');
figh.showDialog(okbtn);

tg = get(figh,'tag');
if strcmp(tg, 'ok')
    mout = gui_globalmodsetup(p.info, 'finalise', lyt, p);
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
    ud.IsTrainingShown = true;
    ShowTrain = true;
    if nargin>4
        for n = 1:2:length(varargin)
            switch lower(varargin{n})
                case 'callback'
                    ud.callback = varargin{n+1};
                case 'training'
                    ud.IsTrainingShown = varargin{n+1};
            end
        end
    end
    ud.pointer = p;
    ud.figure = figh;
    m = p.info;
    
    % Set up the xregoptmgr if it doesn't already exist
    om = getFitOpt(m);
    if ~isa(om,'xregoptmgr')
        alg = @trialwidths;
        om = feval(alg,m);
        m = setFitOpt(m,om);
        p.info = m;
    end

    % Pointer to optimmgr
    ud.ompointer = xregGui.RunTimePointer(om);
    ud.ompointer.LinkToObject(figh);
    
    SC = xregGui.SystemColorsDbl;
    
    % Kernel pop-up menu
    ud.kernel = xreguicontrol('parent', figh,...
        'style','popupmenu',...
        'backgroundcolor',SC.WINDOW_BG,...
        'string', {'multiquadric', 'recmultiquadric', 'gaussian', 'thinplate', ...
        'logisticrbf', 'wendland', 'linearrbf', 'cubicrbf' }, ...
        'callback', {@i_editkernel, pUD},...
        'visible','off');
    KernelLbl = xregGui.labelcontrol('parent',figh,...
        'LabelSizeMode','absolute',...
        'LabelSize',65,...
        'ControlSize',150,...
        'Gap', 5, ...
        'string','RBF kernel:',...
        'control', ud.kernel,...
        'visible','off');
    
    % Continuity popup for Wendland
    ud.cont = xreguicontrol('parent', figh,...
        'style','popup',...
        'string',{'0','2','4','6'},...
        'backgroundcolor',SC.WINDOW_BG,...
        'callback',{@i_editcont, pUD},...
        'visible','off');
    ContLbl = xregGui.labelcontrol('parent',figh,...
        'LabelSizeMode','absolute',...
        'LabelSize',55,...
        'ControlSize',50,...
        'Gap', 5, ...
        'string','Continuity:',...
        'control', ud.cont,...
        'visible','off');
    
    % Width edit box and checkbox
    ud.width = xreguicontrol('parent', figh,...
        'style', 'edit', ...
        'callback',{@i_editwidth, pUD},...
        'visible','off', ...
        'HorizontalAlignment', 'right', ...
        'BackgroundColor', SC.WINDOW_BG);
    WidthLbl = xregGui.labelcontrol('parent',figh,...
        'LabelSizeMode','absolute',...
        'LabelSize',70,...
        'ControlSize', 80, ...
        'string','Initial width:',...
        'visible','off', ...
        'Control', ud.width);
    ud.widthcheck =  uicontrol('parent', figh,...
        'style','checkbox',...
        'string','Use default width',...
        'callback',{@i_widthcheck, pUD},...
        'visible','off');

    % Lambda edit box
    ud.lambda = xregGui.clickedit('parent', figh,...
        'callback',{@i_editlambda, pUD},...
        'visible','off', ...
        'min', 0, ...
        'dragincrement', 1e-4, ...
        'clickincrement', 1e-3);
    LambdaLbl = xregGui.labelcontrol('parent',figh,...
        'LabelSizeMode','absolute',...
        'LabelSize',70,...
        'ControlSize', 80, ...
        'string','Initial lambda:',...
        'visible','off', ...
        'Control', ud.lambda);

    if ud.IsTrainingShown
        % Create the optim manager tree setup component and an advanced
        % button
        ud.basicLayout = gui_setup(om,'layout', ...
            {'expanded', 1, 'topname', 'Algorithm', 'basiclayout', true}, ...
            figh, ud.ompointer, m);
        ud.advancedBtn = uicontrol('parent',figh,'style','pushbutton',...
            'Backgroundcolor',get(0,'defaultuicontrolBackgroundcolor'),...
            'horizontalAlign','right',...
            'string','Advanced...', ...
            'callback',{@i_openadvanced, pUD});
        ud.optionsTitle = xreguicontrol('parent',figh, ...
            'style','text',...
            'enable', 'inactive', ...
            'horizontalAlign', 'left',...
            'string','Setup:');
        ud.trainLayout = xreggridbaglayout(figh, ...
            'packstatus', 'off', ...
            'dimension', [3 2], ...
            'gapx', 10, ...
            'rowsizes', [18 25 -1], ...
            'colsizes', [-1 85], ...
            'mergeblock', {[2 3], [1 1]}, ...
            'elements', {ud.optionsTitle, ud.basicLayout, [], [], ud.advancedBtn, []});
    else
        % Do not bother making the options tree
        ud.basicLayout = [];
        ud.advancedBtn = [];
        ud.trainLayout = [];
        ud.optionsTitle = [];
    end
    
    % Put together the layouts
    OptsGrid = xreggridbaglayout(figh, ...
        'packstatus', 'off', ...
        'dimension', [3 2], ...
        'rowsizes', [20 20 -1], ...
        'colsizes', [160 -1], ...
        'gapx', 10, ...
        'gapy', 5, ...
        'mergeblock', {[3 3], [1 2]}, ...
        'elements', {WidthLbl, LambdaLbl, ud.trainLayout, ud.widthcheck});
    OptsFrame = xregframetitlelayout(figh, ...
        'visible', 'off', ...
        'title', 'Training options', ...
        'center', OptsGrid, ...
        'innerborder', [15 10 10 10]);

    ud.contCard = xregcardlayout(figh, ...
        'visible', 'off');
    attach(ud.contCard, ContLbl, 2);
    
    lyt = xreggridbaglayout(figh, ...
        'dimension', [2 3], ...
        'rowsizes', [20 -1], ...
        'colsizes', [220 120 -1], ...
        'gapx', 30, ...
        'gapy', 10, ...
        'mergeblock', {[2 2], [1 3]}, ...
        'elements', {KernelLbl, OptsFrame, ud.contCard}, ...
        'userdata', pUD);
else
    % get the userdata
    lyt = figh;
    pUD = get(lyt, 'userdata');
    ud = pUD.info;
    ud.pointer = p;
end

pUD.info = ud;
lyt = i_fillfields(p, ud, lyt);






function lyt = i_fillfields(p,ud,lyt)
m = p.info;
SC = xregGui.SystemColorsDbl;

% Kernel popup value
kern = lower(get(m,'kernel'));
kern_opts = get(ud.kernel, 'string');
val = strmatch(kern,kern_opts, 'exact');
set(ud.kernel,'value',val);

% Width value
w = get(m,'width');
if length(w)==1 && w<0
    % Turn on default width checkbox
    set(ud.width, 'string', '', ...
        'enable','off', 'backgroundcolor', SC.CTRL_BG);
    set(ud.widthcheck, 'value', 1);
else
    set(ud.width, 'string', prettify(w), ...
        'enable','on', 'backgroundcolor', SC.WINDOW_BG);
    set(ud.widthcheck, 'value', 0);

end
    
% Lambda value
lambda = get(m,'lambda');
if length(lambda) == 1
    ud.lambda.Value = lambda;
else
    ud.lambda.Value = 1e-4;
end

% Continuity
k = get(m,'cont');
[unused, val] = min(abs(k-[0 2 4 6]));
set(ud.cont,'value',val);
if strcmp(kern,'wendland')
    % Allow continuity to be changed for Wendland's function
    set(ud.contCard,'currentcard',2);
else
    set(ud.contCard,'currentcard',1);
end



function i_editwidth(h,EventData,pUD)
ud = pUD.info;
m = ud.pointer.info;
w = str2num(get(ud.width, 'String'));
w = w(:)';
if (length(w)==1 || length(w)==nfactors(m)) ...
        && all(isfinite(w)) && all(w>=0)
    m = set(m ,'width', w);
    ud.pointer.info = m;
    if ~isempty(ud.callback)
        i_firecb(ud.callback,ud.pointer);
    end
else
    % Restore to previous value
    w = get(m, 'width');
end

% Always reset the string to make sure we display the nicest version of
% what is type in
set(ud.width, 'String', prettify(w));


function i_widthcheck(h,EventData,pUD)
ud = pUD.info;
m = ud.pointer.info;
SC = xregGui.SystemColorsDbl;
if get(ud.widthcheck,'value') > 0
    set(ud.width,'enable','off', 'backgroundcolor', SC.CTRL_BG);
    m = set(m,'width',-1);
else
    set(ud.width,'enable','on', 'backgroundcolor', SC.WINDOW_BG);
    m = set(m,'width', str2num(get(ud.width, 'string')));
end
ud.pointer.info = m;
if ~isempty(ud.callback)
    i_firecb(ud.callback,ud.pointer);
end


function i_editkernel(h, EventData, pUD)
ud = pUD.info;
m = ud.pointer.info;
val = get(ud.kernel,'value');
kern = get(ud.kernel,'string');
kern = kern{val};
m = set(m,'kernel',kern);

% Show the continuity card if  Wendland
if strcmp(kern,'wendland')
    set(ud.contCard,'currentcard',2);
else
    set(ud.contCard,'currentcard',1);
end

ud.pointer.info = m;
if ~isempty(ud.callback)
    i_firecb(ud.callback,ud.pointer);
end


function i_editlambda(h,EventData, pUD)
ud = pUD.info;
m = ud.pointer.info;
newlambda = ud.lambda.Value;
m = set(m,'lambda',newlambda);
ud.pointer.info = m;
if ~isempty(ud.callback)
    i_firecb(ud.callback,ud.pointer);
end


function i_editcont(h,EventData, pUD)
ud = pUD.info;
m = ud.pointer.info;
val = get(ud.cont,'value');
contopts = [0 2 4 6];
newcont = contopts(val);
m = set(m,'cont', newcont);
ud.pointer.info = m;
if ~isempty(ud.callback)
    i_firecb(ud.callback,ud.pointer);
end


function i_openadvanced(h, EventData, pUD)
ud = pUD.info;
PR = xregGui.PointerRepository;
ptrID = PR.stackSetPointer(ud.figure, 'watch');
m = ud.pointer.info;
om = ud.ompointer.info;
[om, OK] = gui_setup(om, 'figure', { ...
    'expanded', 1, ...
    'title','Radial Basis Function Options', ...
    'topname', 'RBF training algorithm' }, ...
    m );

if OK
    m = setFitOpt(m, om);
    ud.pointer.info = m;
    ud.ompointer.info = om;

    % update the basic options
    delete(ud.basicLayout);
    ud.basicLayout = gui_setup(om, 'layout', ...
        {'expanded', 1, 'topname', 'Algorithm', 'basiclayout', true}, ...
        ud.figure, ud.ompointer, m);
    set(ud.trainLayout, 'elements', ...
        {ud.optionsTitle, ud.basicLayout, [], [], ud.advancedBtn, []}, ...
        'packstatus', 'on');

    pUD.info = ud;
    
    if ~isempty(ud.callback)
        i_firecb(ud.callback,ud.pointer);
    end
end
PR.stackRemovePointer(ud.figure, ptrID);



function i_firecb(cbstr,ptr)
% parse callback string and execute it
if ~isempty(cbstr) && ischar(cbstr)
    % parse for %MODEL% and %POINTER%

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
