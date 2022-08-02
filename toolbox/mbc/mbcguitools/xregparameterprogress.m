function out = xregparameterprogress( action, varargin )
%XREGALPHAPROGRESS Display progress when searching for a best parameter
%   FIGH = XREGALPHAPROGRESS('Setup',TITLE,HEAD1,WIDTH1,HEAD2,WIDTH2,...) sets 
%   up a window with given TITLE and containing a table with column heads and 
%   widths as given. TITLE, HEAD1, HEAD2, ..., should all be strings; WIDTH1, 
%   WIDTH2, ..., should be integers.
%
%   XREGALPHAPROGRESS('Add',FIGH,ITEM,SUBITEM1,SUBITEM2,...) adds a new item to 
%   the progress window. ITEM goes in the first column and SUBITEM1, 
%   SUBITEM2, ..., go into the subsequent columns. If there are more items, 
%   i.e., ITEM and SUBITEMs, than columns in the table, there will be an error.
%   ITEM, SUBITEM1, SUBITEM2, ..., should all be strings.
%
%   XREGALPHAPROGRESS('SetBest',FIGH) sets the current, i.e., last added, item 
%   as best. This means the item is displayed in red and bold. The previous 
%   best item has its color returned to black, but stays bold.
%
%   XREGALPHAPROGRESS('Disp',FIGH,STRING) displays STRING in grey in the first 
%   column
%
%   XREGALPHAPROGRESS('Close',FIGH) closes the progress window.
%   XREGALPHAPROGRESS('Close',FIGH,T) pauses for T seconds before closing the 
%   window.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.2 $ 

switch lower( action ),
case 'setup',
    out = i_Setup( varargin{:} );
case 'add',
    i_Add( varargin{:} );
case 'setbest',
    i_SetBest( varargin{:} );
case 'disp',
    i_Disp( varargin{:} );
case 'close',
    i_Close( varargin{:} );
end

return

%------------------------------------------------------------------------------|
function figh = i_Setup( Title, varargin );

if ~mod( nargin, 2 ),
    error( 'Column headers and sizes must occur in pairs' );
end

figh = xregfigure(...
    'Name', Title,...
    'Visible', 'off' );
xregcenterfigure( figh, [350, 400] );

%
% ActiveX ListView setup
list = xregGui.listview([0, 0, 10, 10], ...
    double( figh ) );

list.FullRowSelect = 1;
list.View = 3; % lvwReport view
list.LabelEdit = 1;
list.Parent = double( figh );
list.HideColumnHeaders = 0;

ch = list.ColumnHeaders;
for i = 1:2:(nargin-1),
    head = invoke( ch, 'add' );
    head.Text  = varargin{i};
    head.Width = varargin{i+1};
end

lyt = xreggridlayout( figh,...
    'dimension', [2,1],...
    'correctalg','on',...
    'rowsizes',[-1,25],...
    'gapy',10,...
    'border',[20,10,20,20],...
    'packstatus','off',...
    'elements',{actxcontainer( list ), []});

figh.layoutmanager = lyt;
set( lyt, 'packstatus', 'on');
set( figh, 'Visible', 'on');
drawnow

% Setup figure UserData
set( figh, 'UserData', struct( ...
    'listitems', list.listitems, ...
    'bestitem', [], ...
    'item', [] ) );

return

%------------------------------------------------------------------------------|
function i_Add( figh, first, varargin );
ud = get( figh, 'UserData' );

it = invoke( ud.listitems, 'add' );  
it.text = sprintf( '%s', first );
for i = 1:(nargin-2),
    set( it, 'subitems', i, sprintf( '%s', varargin{i} ) );
end
invoke( it, 'EnsureVisible' );
drawnow

ud.item = it;
set( figh, 'UserData', ud );
return

%------------------------------------------------------------------------------|
function i_SetBest( figh, varargin );
ud = get( figh, 'UserData' );
it = ud.item;

if ~isempty( ud.bestitem ),
    set( ud.bestitem, 'ForeColor', 0 ); % black
end
set( it, 'ForeColor', 255 ); % red
set( it, 'Bold', 1 );
drawnow

ud.bestitem = it;
set( figh, 'UserData', ud );
return

%------------------------------------------------------------------------------|
function i_Disp( figh, varargin );
ud = get( figh, 'UserData' );

it = invoke( ud.listitems, 'add' );  
it.text = varargin{1};
set( it, 'ForeColor', 12632256 ); % grey
invoke( it, 'EnsureVisible' );
drawnow

return

%------------------------------------------------------------------------------|
function i_Close( figh, varargin );

if nargin,
    pause( varargin{1} ); 
end
close( figh );

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

