function out = check( c, X, action )
%CHECK   Check a constar constraint against its data
%  CHECK(C, X) pops up a window that give somes statistics regarding how
%  well the  bdrydev object C constrains X.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.3 $    $Date: 2004/04/04 03:32:08 $ 

error( nargchk( 1, 2, nargin ) );
if nargin < 3, 
    action = 'figure'; 
end

out = [];

switch lower( action ),
case 'figure'
    i_createfig( c, X );
case 'stats'
    out = i_checkstats( c, X );
otherwise
    warning( sprintf( 'Unknown action "%s"', action ) );
end

%---------------------------------|--------------------------------------------|
function i_createfig( c, X );
figh = xregdialog(...
    'name','Constraint Information',...
    'resize','OFF');
xregcenterfigure(figh,[210 145]);

lyt = i_createlyt( c, X, figh );

btnClose = uicontrol(...
    'parent',figh,...
    'style','pushbutton',...
    'string','Close',...
    'interruptible','off',...
    'callback','set(gcbf,''visible'',''off'');');
grd = xreggridbaglayout(figh,...
    'dimension',[2 2],...
    'rowsizes',[-1 25],...
    'colsizes',[-1 65],...
    'gapy',10,'gapx',7,...
    'border',[7 7 7 7],...
    'mergeblock',{[1 1],[1 2]},...
    'elements',{lyt,[],[],btnClose});
figh.LayoutManager=grd;
set( grd, 'packstatus', 'on' );

figh.showDialog(btnClose);

tg = get(figh,'tag');

delete(figh);
return

%---------------------------------|--------------------------------------------|
function axh = i_createlyt( c, X, figh );
stats = i_checkstats(c,X);

axh = xregaxes( ...
    'Parent', figh,...
    'Units','pixels',...
    'Visible','off' );

str = {'Data points:',...
    [    'Total: ' num2str(stats.Total) ], ...
    [ 'Boundary: ' num2str(stats.Boundary) ], ...
    [ 'Interior: ' num2str(stats.Interior) ], ...
    [ 'Exterior: ' num2str(stats.Exterior) ] };
bold =   [ 1; 0; 0; 0; 1 ];
indent = [ 0; 1; 1; 1; 1 ];

xregtextlist( axh, [0 0 0], str, indent, bold, 7, 15 );

return

%---------------------------------|--------------------------------------------|
function out = i_checkstats( c, X );

ndata = size( X, 1 );
ind = setdiff( 1:ndata, c.BdryPoints );
X = X(ind,:);
d = constraindist( c, X ) ;

out.Total = ndata;
out.Boundary = length( c.BdryPoints );
out.Interior = length( find( d <  0 ) );
out.Exterior = length( find( d >= 0 ) );

return

%---------------------------------|--------------------------------------------|
% EOF
%---------------------------------|--------------------------------------------|
