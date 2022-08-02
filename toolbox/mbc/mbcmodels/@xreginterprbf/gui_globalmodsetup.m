function [mout,ok]=gui_globalmodsetup(m,action,varargin);
%GUI_GLOBALMODSETUP  GUI for altering xreginterprbf settings
%
%   [M,OK]=GUI_GLOBALMODSETUP(M) creates a blocking GUI for choosing the
%   subclass of linearmodel and altering its settings.  OK indicates
%   whether the user pressed 'OK' or 'Cancel'.
%
%   LYT=GUI_GLOBALMODSETUP(M,'layout',FIG,P) creates a layout in figure
%   FIG, using the dynamic copy of a model in P.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.4 $    $Date: 2004/04/04 03:30:04 $

if nargin<2
    action='figure';
end

switch lower(action)
    case 'figure'
        [mout,ok] = i_createfig(m);

    case 'layout'
        mout = i_createlyt(varargin{:});
        ok = 1;

    case 'getclasslevel'
        mout = mfilename('class');

    case 'finalise',
        mout = m;
end



function [mout,ok] = i_createfig(m, varargin)
figh = xregdialog('name','Interpolating RBF Model Settings',...
    'resize','off');
xregcenterfigure(figh, [500, 300]);

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
    mout = p.info;
    ok = 1;
else
    mout = m;
    ok = 0;
end
delete(figh);



function lyt=i_createlyt(figh,p)

if ~isa(figh,'xregcontainer')
    ud.pointer = p;
    ud.figure = figh;
    m = p.info;

    rbfpart = get( m, 'rbfpart' );
    linearmodpart = get( m, 'linearmodpart' );
    om = get( m, 'fitalg' );

    rbfp = xregGui.RunTimePointer( rbfpart );
    lmp  = xregGui.RunTimePointer( linearmodpart );
    omp  = xregGui.RunTimePointer( om );
    udp = xregGui.RunTimePointer;
    
    ud.btnAdvanced = xreguicontrol( ...
        'parent',figh,...
        'style','pushbutton',...
        'string','Advanced...', ...
        'callback',{@i_btnAdvanced,p} );

    lytLinearPart = gui_globalmodpane( linearmodpart, 'layout', ...
        figh, lmp, 'Callback', {@i_updateLinearModPart,p,lmp} );

    ud.checkPolyFromKernel = xreguicontrol( figh,...
        'style','checkbox',...
        'string', 'Polynomial from kernel', ...
        'value',get( om, 'PolyFromKernel' ), ...
        'min', 0, 'max', 1, ...
        'callback',{@i_polyFromKernel,p,omp,lytLinearPart},...
        'visible','off',...
        'interruptible','off');

    i_polyFromKernel(ud.checkPolyFromKernel,[],p,omp,lytLinearPart);

    lytLinearPart = xreggridbaglayout( figh, ...
        'packstatus', 'off', ...
        'dimension', [2,1], ...
        'rowsizes', [20, -1], ...
        'gapy', 7, ...
        'elements', { ud.checkPolyFromKernel, lytLinearPart } );

    lytLinearPart = xregframetitlelayout( figh, ...
        'Visible', 'off', ...
        'Title', 'Polynomial part', ...
        'Center', lytLinearPart);

    lytRbfPart = gui_rbfpane( m, 'layout', ...
        figh, rbfp, 'Callback', {@i_updateRbfPart,p,rbfp} );
    lytRbfPart = xregframetitlelayout( figh, ...
        'Visible', 'off', ...
        'Title', 'RBF part', ...
        'Center', lytRbfPart);

    lyt = xreggridbaglayout(figh, ...
        'dimension', [2 4], ...
        'rowsizes', [-1 25], ...
        'colsizes', [85 -1 -1 85], ...
        'gapy', 10, ...
        'gapx', 7, ...
        'mergeblock', {[1 1], [1 2]}, ...
        'mergeblock', {[1 1], [3 4]}, ...
        'elements', {lytRbfPart, ud.btnAdvanced, [],[], lytLinearPart}, ...
        'userdata', udp);

else
    lyt = figh;
    udp = get(lyt, 'userdata');
    ud = udp.info;
    % update with new pointer
    ud.pointer = p;
end
udp.info = ud;



function i_btnAdvanced(h,evt,p)
m=p.info;
om = get( m, 'fitalg' );
om = gui_setup( om,'figure', {...
    'expanded',1,...
    'title', 'Advanced Options',...
    'topname', 'Fit algorithm'},...
    m );
m = set( m, 'fitalg', om );
p.info = m;


function i_updateLinearModPart(h,evt,p,lmp);
p.info = set( p.info, 'linearmodpart', lmp.info );


function i_updateRbfPart(h,evt,p,rbfp);
p.info = set( p.info, 'rbfpart', rbfp.info );


function i_polyFromKernel(h,evt,p,omp,lyt);
if get( h, 'Value' ) == get( h, 'Max' ),
    omp.info = set( omp.info, 'PolyFromKernel', logical(1) );
    set( lyt, 'Enable', 'off' );
else
    omp.info = set( omp.info, 'PolyFromKernel', logical(0) );
    set( lyt, 'Enable', 'on' );
end
p.info = set( p.info, 'fitalg', omp.info );
