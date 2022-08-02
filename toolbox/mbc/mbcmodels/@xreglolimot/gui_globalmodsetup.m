function [mout, ok] = gui_globalmodsetup( m, action, varargin );
%GUI_GLOBALMODSETUP GUI for altering XREGLOLIMOT settings
%
%  [M,OK]=GUI_GLOBALMODSETUP(M) creates a blocking GUI for choosing the
%  XREGLOLIMOT options and altering its settings.  OK indicates whether the
%  user pressed 'OK' or 'Cancel'.
%
%  LYT=GUI_GLOBALMODSETUP(M,'layout',FIG,P) creates a layout object in the
%  figure FIG which updates the dynamic copy of a model in the pointer P.
%  Alternatively, if FIG is a handle to a pre-created LYT (using this
%  function) then that layout will be updated with information from the new
%  pointer P.
%
%  LYT=GUI_GLOBALMODSETUP(M,'layout',FIG,P,'callback',CBSTR) attaches a
%  callback string, CBSTR, which is fired when the model definition is
%  changed.  The string may contain the tokens %MODEL% and %POINTR% which
%  will be replaced with the current model and the pointer before the
%  callback is executed.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.3 $  $Date: 2004/04/04 03:30:10 $


if nargin<2
    action = 'figure';
end

switch lower(action)
    case 'figure'
        [mout,ok] = i_createfig(m, varargin{:});

    case 'layout'
        mout = i_createlyt(varargin{:});
        ok = 1;

    case 'getclasslevel'
        mout = class(m);

    case 'finalise',
        lyt = varargin{1};
        pModel = varargin{2};
        pUD = get( lyt, 'UserData' );
        i_finalise(pModel, pUD);
        mout = pModel.info;
        ok = 1;
end




function [mout,ok] = i_createfig(m, varargin)
figh = xregdialog('name','LOLIMOT Model Settings',...
    'resize','off');
xregcenterfigure(figh, [450, 335]);

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
    pUD = get(lyt, 'userdata');
    i_finalise(p, pUD);
    mout = p.info;
    ok = 1;
else
    mout = m;
    ok = 0;
end
delete(figh);



function lyt = i_createlyt(figh,p,varargin)

if ~isa( figh, 'xregcontainer' )
    ud.callback = '';
    if nargin>4
        for n = 1:2:length(varargin)
            switch lower(varargin{n})
                case 'callback'
                    ud.callback = varargin{n+1};
            end
        end
    end
    ud.pointer = p;
    ud.figure = figh;
    m = p.info;

    udp = xregGui.RunTimePointer;
    udp.LinkToObject(figh);

    SC = xregGui.SystemColorsDbl;

    kernelList = kernellist( m );
    kernel = get( m, 'kernel' );
    ud.popupKernel = xreguicontrol('Parent', figh,...
        'style','popupmenu',...
        'string',kernelList,...
        'value',find( strcmpi( kernel, kernelList ) ), ...
        'callback',{@i_kernel,udp},...
        'visible','off',...
        'interruptible','off',...
        'horizontalalignment','left',...
        'backgroundcolor',SC.WINDOW_BG);

    val = find(get(m,'cont')==[0 2 4 6]);
    ud.popupContinuity = xreguicontrol( 'Parent', figh,...
        'style','popupmenu',...
        'string',{ '0', '2', '4', '6'},...
        'value',val,...
        'callback',{@i_continuity,udp},...
        'visible','off',...
        'interruptible','off',...
        'horizontalalignment','left',...
        'backgroundcolor',SC.WINDOW_BG);

    ud.lctrlKernel = xregGui.labelcontrol( ...
        'parent',figh,...
        'visible','off',...
        'String','Kernel:',...
        'ControlSize', 1, ...
        'ControlSizeMode', 'relative',...
        'LabelSize', 50, ...
        'LabelSizeMode', 'absolute', ...
        'Gap', 5, ...
        'Control', ud.popupKernel);

    ud.lctrlContinuity = xregGui.labelcontrol( ...
        'parent',figh,...
        'visible','off',...
        'string','Continuity:',...
        'ControlSize', 1, ...
        'ControlSizeMode', 'relative',...
        'LabelSize', 50, ...
        'LabelSizeMode', 'absolute', ...
        'Gap', 5, ...
        'Control', ud.popupContinuity);

    ud.btnAdvanced = xreguicontrol( ...
        'parent',figh,...
        'visible','off',...
        'style','pushbutton',...
        'string','Advanced...', ...
        'callback',{@i_btnAdvanced,udp});

    om = getFitOpt( m );
    ud.pOptionsMgr = xregGui.RunTimePointer( om );
    ud.pOptionsMgr.LinkToObject( figh );
    ud.basicFitOptions = gui_setup( om, 'layout', ...
        {'expanded', 1, 'topname', 'Algorithm', 'basiclayout', true}, ...
        figh, ud.pOptionsMgr, m );

    ud.trainingGrid = xreggridbaglayout(figh, ...
        'packstatus', 'off', ...
        'dimension', [2 2], ...
        'gapx', 10, ...
        'rowsizes', [25 -1], ...
        'colsizes', [-1 85], ...
        'mergeblock', {[1 2], [1 1]}, ...
        'elements', {ud.basicFitOptions, [], ud.btnAdvanced, []});
    lytTraining = xregframetitlelayout( figh, ...
        'Title', 'Training options', ...
        'Center', ud.trainingGrid, ...
        'InnerBorder', [10, 10, 10, 10], ...
        'visible', 'Off');

    lyt = xreggridbaglayout(figh,...
        'dimension',[2, 3],...
        'colsizes', [200, 100, -1], ...
        'rowsizes',[20 -1],...
        'gapy',10,'gapx',30,...
        'mergeblock', {[2 2], [1 3]}, ...
        'elements',{ud.lctrlKernel, lytTraining ud.lctrlContinuity} );

    udp.info = ud;
    set( lyt, 'UserData', udp );

    i_enableContinuity(udp,kernel);
else
    lyt = figh;
    pUD = get(lyt, 'userdata');
    ud = pUD.info;

    % update with new pointer
    ud.pointer = p;
end



function i_kernel(h,evt,udp)

ud=udp.info;
m=ud.pointer.info;

value = get( ud.popupKernel, 'value' );
kernelList = get( ud.popupKernel, 'string' );
kernel = kernelList{ value };
set( m, 'kernel', kernel );
set( m, 'fitalg', 'rbffit' );

i_enableContinuity(udp,kernel);

ud.pointer.info = m;
i_firecb(ud.callback,ud.pointer);


function i_continuity(h,evt,udp)

ud=udp.info;
m=ud.pointer.info;

value = get( ud.popupContinuity, 'value' );
list = get( ud.popupContinuity, 'string' );
continuity = list{ value };
set( m, 'cont', str2num( continuity ) );
set( m, 'fitalg', 'rbffit' );

ud.pointer.info = m;
i_firecb(ud.callback,ud.pointer);



function i_enableContinuity(udp,kernel)

if strcmpi( kernel, 'wendland' ),
    set( udp.info.lctrlContinuity, 'Enable', 'on' );
else
    set( udp.info.lctrlContinuity, 'Enable', 'off' );
end


function i_btnAdvanced(h,evt,udp)
ud = udp.info;
m = ud.pointer.info;
om = ud.pOptionsMgr.info;

PR = xregGui.PointerRepository;
ptrID = PR.stackSetPointer(ud.figure, 'watch');

% start up options dialog
[om, OK] = gui_setup( om, 'figure', { ...
    'expanded', 1, ...
    'title','LOLIMOT Fit Options',...
    'topname', 'Training algorithm' }, m );
if OK
    % set options in model
    m = setFitOpt( m, om );
    m = set( m, 'fitalg', 'rbffit' );
    ud.pointer.info = m;

    % fire callback
    i_firecb(ud.callback,ud.pointer);

    ud.pOptionsMgr.info = om;

    % update the basic options
    delete( ud.basicFitOptions );
    ud.basicFitOptions = gui_setup( om, 'layout', ...
        {'expanded', 1, 'topname', 'Algorithm', 'basiclayout', true}, ...
        ud.figure, ud.pOptionsMgr, m );
    set(ud.trainingGrid, ...
        'elements',  {ud.basicFitOptions, [], ud.btnAdvanced, []}, ...
        'packstatus', 'on');

    % update data on heap
    udp.info = ud;
end
PR.stackRemovePointer(ud.figure, ptrID);


function i_finalise(pModel, pUD)
ud = pUD.info;
m = pModel.info;
pModel.info = setFitOpt(m, ud.pOptionsMgr.info);



function i_firecb(cbstr,ptr)
% parse callback string and execute it

if ~isempty(cbstr)
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
end
