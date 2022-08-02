function [y0, ok] = GuiInitialConditions( yname, order, delay, y0 )
%GUIINITIALCONDITIONS  Specifiy a set of initial condtions
%   GUIINITIALCONDITIONS(YNAME,ORDER,DELAY) is a set of inital condtions for a 
%   dynamic model with given feedback ORDER and DELAY. YNAME is the symbol for 
%   the output of the embedded static model that gets feedback.
%   GUIINITIALCONDITIONS(YNAME,ORDER,DELAY,YO) updates the initial conditions Y0.
%   [Y0,OK] = GUIINITIALCONDITIONS(...) returns the flag OK which indicates 
%   which button was pressed: wither the OK button (OK=true) or the Cencel 
%   button (OK=false).
%
%   ORDER and DELAY should be the overall dynamic order and delay vectors.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.3 $  $Date: 2004/04/04 03:29:54 $

% The main layout is handled by an XREGTABLE. This is an easy way to provide a 
% scroll bar when there are too many inputs to fit in the window. The current 
% initial conditions are stored in the UserData of the figure (figh) and the 
% appropriate entry is updated each time its cell is changed. If a cell change 
% leads to some non-numeric entry, the current value overwrites the text.

opdm1 = max( order + delay )-1; % CHECK ME!!!
if nargin < 4,
    y0 = zeros( opdm1, 1 );
elseif numel( y0 ) > opdm1,
    y0 = y0(1:opdm1);
elseif numel( y0 ) < opdm1,
    error( 'Y0 is too short for given ORDER and DELAY' );
end

symbols = i_ExpandSymbol( yname, opdm1  );

%------------------------------------------------------------------------------|
% Set up dialog
figh = xregdialog(...
    'Name', 'Set Initial Conditions',...
    'Resize', 'Off');
xregcenterfigure( figh, [200, 200] );
[lyt, table] = i_CreateLayout( figh, symbols, y0 );

btnCancel = uicontrol( 'Parent', figh,...
    'Style', 'PushButton',...
    'String', 'Cancel',...
    'interruptible','off',...
    'Callback', 'set(gcbf,''visible'',''off'');' );

btnOk = uicontrol( 'Parent', figh,...
    'Style', 'PushButton',...
    'String', 'OK',...
    'interruptible','off',...
    'Callback', 'set(gcbf,''tag'',''ok'',''visible'',''off'');' );

DividerLine = xregGui.dividerline( figh );

lyt = xreggridbaglayout( figh, ...
    'Dimension', [3, 3],...
    'RowSizes', [-1, 2, 25 ],...
    'ColSizes', [-1, 65, 65],...
    'GapY', 5,...
    'GapX', 7,...
    'Border', [5, 5, 5, 5],...
    'MergeBlock', { [1, 1], [1, 3] }, ...
    'MergeBlock', { [2, 2], [1, 3] }, ...
    'Elements', { ...
        lyt, [], []; ...
        DividerLine,  [], []; ...
        [], btnOk, btnCancel } ); 
    
% process any input
set( figh, 'UserData', y0 );

%
% All ready, turn it on
figh.LayoutManager = lyt;
set( lyt, 'packstatus', 'on' );
set( table, 'visible', 'on' );

fig.showDialog(btnOk);

% we wait for the user to close the window

tg = get( figh, 'tag' );
if ~isempty( tg )
   y0 = get( figh, 'UserData' );
else
   ok = 0; % i.e., false
end
delete( figh );

return

%------------------------------------------------------------------------------|
function [lyt, table] = i_CreateLayout( figh, symbols, y0 )

n = length( symbols );

BackgroundColor = get( figh, 'color' );
table = xregtable( double( figh ),...
   'visible', 'off',...
   'frame.visible', 'off',...
   'frame.hborder', [0, 0],...
   'frame.vborder', [0, 0],...
   'defaultcellformat', '%g',...
   'defaultcelltype', 'uiedit',...
   'cols.size', 80,...
   'cols.spacing', 2,...
   'rows.spacing', 2,...
   'cells.defaultinterruptible', 'off',...
   'cells.rowselection', [1, n],...
   'cells.colselection', [1, 1],...
   'cells.type','uitext',...
   'cells.string', symbols,...
   'cells.backgroundcolor', BackgroundColor,...
   'cols.fixed', 1,...
   'zeroindex',[1, 2],...
   'cells.defaultbackgroundcolor', [1, 1, 1],...
   'cells.rowselection',[1, n],...
   'cells.colselection',[2, 2],...
   'cells.type','uiedit',...
   'cells.string', cellstr( num2str( y0(:) ) ),...
   'cells.horizontalalignment','right',...
   'position', [0, 0, 300, 70],...
   'redrawmode', 'basic');
table.redrawmode = 'normal';
table.cellchangedcallback = {@i_CellChange, figh};

lyt = xregpanellayout( figh, ...
    'innerborder', [5 0 0 0], ...
    'center', table );

return

%------------------------------------------------------------------------------|
function new = i_ExpandSymbol( symbol, opdm1 )
% opd = o(rder) p(lus) d(elay) m(inus) (one)

new = cell( opdm1, 1 );
for j = 1:opdm1,
    new{j} = strcat( symbol, '(', int2str( j-1 ), ')' );
end

return

%------------------------------------------------------------------------------|
function i_CellChange( table, evt, figh )

y0 = get( figh, 'UserData' );
ind = evt.Row;

num = str2num( table(ind,1).string );
if isempty( num ) | ~isreal( num ),
    table(ind,1).string = num2str( y0(ind) );
else
    y0(ind) = num;
    set( figh, 'UserData', y0 );
end


return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
