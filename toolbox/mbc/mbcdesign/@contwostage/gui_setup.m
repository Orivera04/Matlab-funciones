function [out, ok] = gui_setup( con, action, varargin )
%GUI_SETUP   Model parameter setup for constraint modelling
%   [C,OK] = GUI_SETUP(C) or GUI_MODEL(C,'Figure') creates a blocking GUI for 
%   choosing the parameters of a constraint model.  It returns M, a new copy of 
%   the constraint model, and OK, which indicates whether the user pressed 'OK' 
%   or 'CANCEL'.
%   LYT = GUI_SETUP(C,'Layout',FIG,P) creates a layout in figure FIG, using the 
%   dynamic copy of a model in P.
%   [MSG, OK] = GUI_SETUP(C,'Finalise',LYT) fiddles the user data field of the 
%   layout LYT so that the conmodel reflects the selected parameters.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.3 $    $Date: 2004/04/04 03:26:32 $ 

if nargin < 1, 
    con = contwostage;
end
if nargin < 2, 
    action = 'Figure';
end

switch lower( action ),
case 'figure',
    [out, ok] = i_figure( con, varargin{:} );
case 'layout',
    [out, ok] = i_layout( con, varargin{:} );
case 'finalise',
    i_finalise( varargin{1} );
    ok = true;
    out = '';
otherwise,
    warning( sprintf( 'Unknown action ''%s''.', action ) );
end

return

%------------------------------------------------------------------------------|
function [con, ok] = i_figure( con, varargin )
p = xregpointer(con);

figh = xregdialog( ...
    'Name', 'Two-Stage Boundary Settings', ...
    'numbertitle', 'off', ...
    'closerequestfcn','set(gcbf,''tag'',''cancel'');',...
    'resize','off' );

xregcenterfigure( figh, [300, 200] );

lyt = i_layout( figh, p );

btnOk = xreguicontrol(...
    'parent',figh,...
    'style','pushbutton',...
    'string','OK',...
    'interruptible','off',...
    'callback','set(gcbf,''tag'',''ok'',''visible'',''off'');');

btnCancel = xreguicontrol(...
    'parent',figh,...
    'style','pushbutton',...
    'string','Cancel',...
    'interruptible','off',...
    'callback','set(gcbf,''tag'',''cancel'',''visible'',''off'');');

dividerline = xregGui.dividerline( 'parent', figh );

grd = xreggridbaglayout(figh,...
   'dimension',[3 3],...
   'rowsizes',[-1, 4, 25],...
   'colsizes',[-1, 65, 65],...
   'gapy',10,'gapx',7,...
   'border',[7 7 7 7],...
   'mergeblock',{[1 1],[1 3]},...
   'mergeblock',{[2 2],[1 3]},...
   'elements',{...
       lyt,[],[];...
       dividerline,[],[];...
       [],btnOk,btnCancel});

figh.LayoutManager = grd;
set( grd, 'packstatus', 'on' );

figh.showDialog(btnOk);

tg = get( figh, 'tag' );

ok = strcmpi( tg, 'ok' );
i_finalise( lyt )
con = p.info;

freeptr( p );
delete( figh );
return
%------------------------------------------------------------------------------|
function [lyt, ok] = i_layout( figh, p, varargin )

udp = xregGui.RunTimePointer;
udp.LinkToObject( figh );

con = p.info;


local_list  = localclasses( con );
lval = find( strcmpi( class( con.Local ), {local_list.Class} ) );
ud.popupLocal = xreguicontrol( figh,...
    'style','popupmenu',...
    'string',{local_list.Name},...
    'value',lval, ...
    'callback',{@i_local,udp},...
    'visible','off',...
    'interruptible','off',...
    'horizontalalignment','left',...
    'backgroundcolor','w');
ud.lctrlLocal = i_labelcontrol( figh, 'Local Constraint', ud.popupLocal );

global_list = globalclasses( con );
gval = find( strcmpi( class( con.Global{1} ), {global_list.Class} ) );
ud.popupGlobal = xreguicontrol( figh,...
    'style','popupmenu',...
    'string',{global_list.Name},...
    'value',gval, ...
    'callback',{@i_global,udp},...
    'visible','off',...
    'interruptible','off',...
    'horizontalalignment','left',...
    'backgroundcolor','w');
ud.lctrlGlobal = i_labelcontrol( figh, 'Global Model', ud.popupGlobal );

ud.btnGlobal = xreguicontrol(...
    'parent', figh,...
    'style', 'pushbutton',...
    'string', 'Set up...',...
    'interruptible','off',...
    'callback',{@i_setup,udp});

lyt = xreggridbaglayout(figh,...
    'dimension',[4, 2],...
    'rowsizes',[20, 20, 25, -1],...
    'colsizes',[-1, 65],...
    'gapy',5, 'gapx',7,...
    'border',[0 0 0 0],...
    'MergeBlock', {[1, 1], [1, 2]}, ...
    'MergeBlock', {[2, 2], [1, 2]}, ...
    'elements',{... ...
        ud.lctrlLocal,  []; ...
        ud.lctrlGlobal, []; ...
        [],             ud.btnGlobal; ...
        [],             [] } );

ud.ptr = p;
set( lyt, 'UserData', ud );
udp.info = ud;

ok = 1;
return
%------------------------------------------------------------------------------|
function lctrl = i_labelcontrol( figh, string, control )
lctrl = xregGui.labelcontrol( ...
    'parent',figh,...
    'Control', control,...
    'String',string,...
    'Enable','on', ...
    'ControlSize', 120, ...
    'ControlSizeMode', 'relative',...
    'LabelSize', 120, ...
    'LabelSizeMode', 'relative');

%------------------------------------------------------------------------------|
function i_finalise( lyt )
ud = get( lyt, 'UserData' );
con = ud.ptr.info;
ud.ptr.info = con;
return
%------------------------------------------------------------------------------|
function i_local( h, evt, udp )

ud = udp.info;
con = ud.ptr.info;

local_list = localclasses( con );
value = get( ud.popupLocal, 'value' );

if ~isa( con.Local, local_list(value).Class ),
    nf = getsize( con.Local );
    con.Local = feval( local_list(value).Class, nf );

    % ensure that the number of global models is correct.
    gm = con.Global{1};
    con.Global = cell( 1, numfeats( con.Local ) );
    [con.Global{:}] = deal( gm );

    ud.ptr.info = con;
end
return
%------------------------------------------------------------------------------|
function i_global( h, evt, udp )

ud = udp.info;
con = ud.ptr.info;

global_list = globalclasses( con );
value = get( ud.popupGlobal, 'value' );

if ~isa( con.Global, global_list(value).Class ),
    nf = nfactors( con.Global{1} );
    [con.Global{:}] = deal( feval( global_list(value).Class, nf ) );
    ud.ptr.info = con;
end
return
%------------------------------------------------------------------------------|
function i_setup( h, evt, udp )

ud = udp.info;
con = ud.ptr.info;

[new, ok] = gui_globalmodsetup( con.Global{1} );
if ok,
    [con.Global{:}] = deal( new );
    ud.ptr.info = con;
end
return
%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
