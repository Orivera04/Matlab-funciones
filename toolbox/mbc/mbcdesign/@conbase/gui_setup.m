function [out, out2] = gui_setup( con, action, varargin )
%GUI_SETUP   Model parameter setup for constraint modelling
%   [C,OK] = GUI_SETUP(C) or GUI_MODEL(C,'Figure') creates a blocking GUI for 
%   choosing the parameters of a constraint model.  It returns M, a new copy of 
%   the constraint model, and OK, which indicates whether the user pressed 'OK' 
%   or 'CANCEL'.
%   LYT = GUI_SETUP(C,'Layout',FIG,P) creates a layout in figure FIG, using the 
%   dynamic copy of a model in P.
%   [OK, MSG] = GUI_SETUP(C,'Finalise',LYT) fiddles the user data field of the 
%   layout LYT so that the conmodel reflects the selected parameters.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.3 $    $Date: 2004/04/04 03:26:24 $ 

if nargin < 2, 
    action = 'Figure';
end

switch lower( action ),
case 'figure',
    [out, out2] = i_figure( con, varargin{:} );
case 'layout',
    [out, out2] = i_layout( varargin{:} );
case 'finalise',
    i_finalise( varargin{1} );
    out = true;
    out2 = '';
otherwise,
    warning( sprintf( 'Unknown action ''%s''.', action ) );
end

return

%------------------------------------------------------------------------------|
function [con, ok] = i_figure( con, varargin )
p = xregpointer(con);

figh = xregdialog( ...
    'Name', 'Constraint Settings', ...
    'numbertitle', 'off', ...
    'closerequestfcn','set(gcbf,''tag'',''cancel'');',...
    'resize','off' );

xregcenterfigure( figh, [600, 300] );

lyt = i_layout( figh, p );

btnOk = uicontrol(...
    'parent',figh,...
    'style','pushbutton',...
    'string','OK',...
    'interruptible','off',...
    'callback','set(gcbf,''tag'',''ok'',''visible'',''off'');');

btnCancel = uicontrol(...
    'parent',figh,...
    'style','pushbutton',...
    'string','Cancel',...
    'interruptible','off',...
    'callback','set(gcbf,''tag'',''cancel'',''visible'',''off'');');

grd = xreggridbaglayout(figh,...
   'dimension',[2 3],...
   'rowsizes',[-1 25],...
   'colsizes',[-1 65 65],...
   'gapy',10,'gapx',7,...
   'border',[7 7 7 7],...
   'mergeblock',{[1 1],[1 3]},...
   'elements',{lyt,[],[],btnOk,[],btnCancel});

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

str = sprintf( 'No further options are avaible for %s constraints', ...
    typename( con ) );

txt = xreguicontrol(...
    'parent', figh,...
    'hittest', 'off',...
    'enable', 'inactive',...
    'style', 'text',...
    'string', str,...
    'horizontalalignment', 'center');

lyt = xreggridlayout( figh, ...
    'dimension', [1, 1],...
    'elements',{ txt } );

ud.ptr = p;
set( lyt, 'UserData', ud );
udp.info = ud;

ok = 1;
return

%------------------------------------------------------------------------------|
function i_finalise( lyt )
ud = get( lyt, 'UserData' );
con = ud.ptr.info;
%% 
ud.ptr.info = con;
return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
