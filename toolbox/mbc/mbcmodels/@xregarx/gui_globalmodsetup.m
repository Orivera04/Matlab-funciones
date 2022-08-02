function [mout, ok] = gui_globalmodsetup( m, action, varargin );
%GUI_GLOBALMODSETUP   GUI for altering XREGARX settings
%
%  [M,OK]=GUI_GLOBALMODSETUP(M) creates a blocking GUI for choosing the
%  XREGARX options and altering its settings.  OK indicates whether the
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

%  $Revision: 1.4.6.3 $  $Date: 2004/04/04 03:29:50 $


if nargin<2
    action='figure';
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
        mout = m;
end


function [mout,ok] = i_createfig(m, varargin)
figh = xregdialog('name','Dynamic ARX Model Settings',...
    'resize','off');
xregcenterfigure(figh, [500, 335]);

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



%------------------------------------------------------------------------------|
function lyt=i_createlyt(figh,p,varargin)

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

    [lytStatic, ud.popupStaticModel] = i_staticModelLayout( m, figh, udp );
    [lytDynamic, ud.table] = i_DynamicOrderTable( m, figh, udp );

    smFitList = {'Series-Parallel','Parallel'};
    smFitValue = strmatch( lower( get( m.StaticModel, 'Mode' ) ), ...
        {'series-parallel','parallel'}, 'exact' );

    popupFitAlg = xreguicontrol( figh,...
        'style','popupmenu',...
        'string', smFitList,...
        'value', smFitValue, ...
        'callback',{@i_popupFitAlg,udp},...
        'visible','off',...
        'interruptible','off',...
        'horizontalalignment','left',...
        'backgroundcolor',SC.WINDOW_BG );

    lctrlFitAlg = xregGui.labelcontrol( ...
        'visible','off',...
        'parent',figh,...
        'Control', popupFitAlg,...
        'String','Fit algorithm:',...
        'ControlSize', 95, ...
        'ControlSizeMode', 'absolute', ...
        'LabelSize', 130, ...
        'LabelSizeMode', 'absolute', ...
        'Gap', 5);

    editFrequency = xreguicontrol(...
        'Parent',figh,...
        'visible','off',...
        'Style','Edit',...
        'String',num2str( m.Frequency ),...
        'Value', m.Frequency,...
        'Max',0,...
        'Min',0,...
        'Interruptible','off',...
        'Callback',{@i_frequency,udp},...
        'BackgroundColor', SC.WINDOW_BG, ...
        'HorizontalAlignment', 'right');

    lctrlFrequency =  xregGui.labelcontrol( ...
        'parent',figh,...
        'visible','off',...
        'Control', editFrequency,...
        'String','Sampling frequency (Hz):',...
        'ControlSize', 60, ...
        'ControlSizeMode', 'absolute', ...
        'LabelSize', 130, ...
        'LabelSizeMode', 'absolute', ...
        'gap', 5);

    lyt = xreggridbaglayout(figh,...
        'dimension',[4, 2],...
        'rowsizes',[80, 20, 20, -1],...
        'colsizes',[-1, -1],...
        'gapy',7,'gapx',7,...
        'MergeBlock', {[1,4], [1,1]}, ...
        'elements',{ ...
        lytDynamic, lytStatic; ...
        [],         lctrlFitAlg; ...
        [],         lctrlFrequency; ...
        [],         []}, ...
        'userdata', udp);

    udp.info = ud;
else
    lyt = figh;
    udp = get(lyt, 'userdata');
    ud = udp.info;
    % update with new pointer
    ud.pointer = p;
    udp.info = ud;
end
ud.lyt = lyt;


function [lyt, popupStaticModel] = i_staticModelLayout( m, figh, udp )
SC = xregGui.SystemColorsDbl;
StaticList = staticlist( m );
StaticModelClass = get( m, 'StaticModelClass' );

popupStaticModel = xreguicontrol( figh,...
    'style','popupmenu',...
    'string',{StaticList.Name},...
    'value',strmatch( StaticModelClass, { StaticList.Class }, 'exact' ), ...
    'callback',{@i_popupStaticModel,udp},...
    'visible','off',...
    'interruptible','off',...
    'horizontalalignment','left',...
    'backgroundcolor',SC.WINDOW_BG, ...
    'UserData', StaticList );

lctrlStaticModel = xregGui.labelcontrol( ...
    'parent',figh,...
    'visible','off',...
    'Control', popupStaticModel,...
    'String','Type:',...
    'ControlSize', 180, ...
    'ControlSizeMode', 'absolute');

btnSetup = xreguicontrol( 'Parent', figh, ...
    'Style', 'PushButton', ...
    'visible','off',...
    'String', 'Set Up...', ...
    'Callback',{@i_btnSetup,udp} );

lyt = xreggridbaglayout( figh,...
    'dimension',[2, 2],...
    'rowsizes', [ 21, 25],...
    'colsizes',[-1, 65],...
    'gapy',5,...
    'MergeBlock', { [1, 1], [1, 2] }, ...
    'elements', { ...
    lctrlStaticModel, [], ...
    [], btnSetup} );

lyt = xregframetitlelayout( figh, ...
    'Title', 'Embedded static model', ...
    'innerborder', [15 10 10 10], ...
    'Center', lyt );



function [lyt, table] = i_DynamicOrderTable( m, figh, udp )

SC = xregGui.SystemColorsDbl;

nf = nfactors( m );
symbols = get( m, 'DynamicSymbols' );
order   = get( m, 'DynamicOrder' );
delay   = get( m, 'Delay' );

BackgroundColor = get( figh, 'color' );
table = xregtable( double( figh ),...
    'visible', 'off',...
    'frame.visible', 'off',...
    'frame.hborder', [0, 0],...
    'frame.vborder', [0, 0],...
    'defaultcellformat', '%g',...
    'defaultcelltype', 'uiedit',...
    'cols.size', 55,...
    'cols.spacing', 2,...
    'rows.spacing', 2,...
    'cells.defaultinterruptible', 'off',...
    'cells.defaultbackgroundcolor', SC.WINDOW_BG,...
    'zeroindex', [2, 2],...
    ... % Title row
    'cells.rowselection', [1, 1],...
    'cells.colselection', [1, 3],...
    'cells.type', 'uitext',...
    'cells.string', {'', 'Order', 'Delay'},...
    'cells.fontweight', 'normal',...
    'cells.backgroundcolor', BackgroundColor,...
    'rows.fixed', 1,...
    ... % Symbol name column
    'cells.rowselection', [2, nf+2],...
    'cells.colselection', [1, 1],...
    'cells.type','uitext',...
    'cells.string', { symbols{:}, 'Feedback:' },...
    'cells.backgroundcolor', BackgroundColor,...
    'cols.fixed', 1,...
    ... % Dynamic order column
    'cells.rowselection', [2, nf+2],...
    'cells.colselection', [2, 2],...
    'cells.type', 'uiedit',...
    'cells.string', cellstr( num2str( order(:) ) ),...
    'cells.horizontalalignment', 'right',...
    ... % Dynamic delay column
    'cells.rowselection', [2, nf+2],...
    'cells.colselection', [3, 3],...
    'cells.type', 'uiedit',...
    'cells.string', cellstr( num2str( delay(:) ) ),...
    'cells.horizontalalignment', 'right' );
table.redrawmode = 'normal';
table.cellchangedcallback = {@i_CellChange, udp};

lyt = xregframetitlelayout( figh, ...
    'Title', 'Dynamic order and delay', ...
    'InnerBorder', [10, 10, 10, 10], ...
    'Center', table );



function i_popupStaticModel(h,evt,udp)

ud=udp.info;
m=ud.pointer.info;

value = get( ud.popupStaticModel, 'value' );
ModelList = get( ud.popupStaticModel, 'userdata' );
set( m, 'StaticModel', ModelList(value).Class );

ud.pointer.info = m;
i_firecb(ud.callback,ud.pointer);



function i_btnSetup(h,evt,udp)

ud=udp.info;
m=ud.pointer.info;

sm = get( m, 'StaticModel' );
[sm, ok] = gui_globalmodsetup( sm );
if ok,
    set( m, 'StaticModel', sm );
end

ud.pointer.info = m;
i_firecb(ud.callback,ud.pointer);


function i_popupFitAlg(h,evt,udp)
ud=udp.info;
m=ud.pointer.info;

sm = m.StaticModel;
switch get( h, 'Value' ),
    case 1,
        sm = set( sm, 'Mode', 'Series-Parallel' );
    case 2,
        sm = set( sm, 'Mode', 'Parallel' );
end
sm = SetStandardFit( sm );

m.StaticModel = sm;

ud.pointer.info = m;
i_firecb(ud.callback,ud.pointer);


function i_frequency(h,evt,udp)

ud=udp.info;
m=ud.pointer.info;

% Check the new value
string = get( h, 'String' );
newvalue = str2double( string );

if isnan( newvalue ) || newvalue < 0,
    value = get( h, 'Value' );
    set( h, 'String', num2str( value ) );
    return
end
value = newvalue;
set( h, 'Value',  value );
set( h, 'String', num2str( value ) );

m = set( m, 'Frequency', value );

ud.pointer.info = m;
i_firecb(ud.callback,ud.pointer);


function i_CellChange( table, evt, udp )
ud = udp.info;
m = ud.pointer.info;

delmat = get( m, 'delmat' );

row = evt.Row;
col = evt.Column;

num = floor( str2num( table(row,col).string ) );
table(row,col).string = num2str( num );

if isempty( num ) || ~isreal( num ) || num < 0,
    % all entries must be postive real numbers
    table(row,col).string = num2str( delmat(col,row) );

elseif col == 2 && row == size( delmat, 2 ) && num < 1,
    % the delay on the feedback must be >= 1
    table(row,col).string = num2str( delmat(2,end) );

else
    delmat(col,row) = num;
    set( m, 'delmat', delmat );
end

% fire call back
ud.pointer.info = m;
i_firecb(ud.callback,ud.pointer);



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