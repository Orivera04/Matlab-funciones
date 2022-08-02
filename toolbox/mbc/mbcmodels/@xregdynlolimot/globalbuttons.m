function hands = globalbuttons( m, action, varargin )
%XREGARX/GLOBALBUTTONS   Global model buttons for XREGDYNLOLIMOT
%   GLOBALBUTTONS(M,FIGH) 
%   GLOBALBUTTONS(M,'ID') 
%   GLOBALBUTTONS(M,'Toolbar') toolbar buttons
%   GLOBALBUTTONS(M,'Utilities') menu items

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.6.1 $  $Date: 2004/02/09 07:45:58 $

if ishandle( action )
    figh = action;
    action = 'create';
end

switch lower( action )
case 'create'
    hands = {};
    
case 'id'
    hands = 'xregdynlolimot';
    
case 'toolbar'
    View = varargin{1};
    Toolbar = get( View.toolbarBtns(1), 'Parent' );
    
    [null, hands] = xregtoolbar( Toolbar, {'uipush'}, ...
        'imageFile', 'viewCenters.bmp',...
        'Tooltipstring', 'View Centers',...
        'clickedcallback', @i_ViewCenters,...
        'transparentcolor', [0 255 0] );
   
case 'utilities'
    View = varargin{1};
    uMenu = findobj( View.menus.model, 'label', '&Utilities' );
    
    LolimotPoles = uimenu( uMenu,...
        'label', 'LOLIMOT &Poles',...
        'Callback', @i_lolimotpoles );
    if poles( m, 'Enable' ),
        set( LolimotPoles, 'Enable', 'on' );
    else
        set( LolimotPoles, 'Enable', 'off' );
    end
    
    PlotTree = uimenu( uMenu,...
        'label', 'LOLIMOT &Tree',...
        'Callback', @i_plottree );
   
    ViewCenters = uimenu( uMenu,...
        'label', '&View Centers',...
        'Callback', {@i_ViewCenters} );
    
    hands = [ LolimotPoles; PlotTree; ViewCenters ];
end

return

%------------------------------------------------------------------------------|
function i_example( src, evt )
% src is the menu handle
% evt is empty
mbH = MBrowser;
p = mbH.CurrentNode;
mdev = p.info;

figh = dynamicdiagnostics( model( mdev ), 'figure', mdev );
mbH.RegisterSubFigure( figh );

return

%------------------------------------------------------------------------------|
function i_lolimotpoles( src, evt )
% src is the menu handle
% evt is empty
mbH = MBrowser;
p = mbH.CurrentNode;
mdev = p.info;
m = model( mdev );

T = [];

if isa( m, 'xregarx' ),
    T = 1/get( m, 'Frequency' ); % sample rate
    m = get( m, 'StaticModel' );
elseif ~isa( m, 'xregdynlolimot' )
    errordlg( 'Model at current node does not support ''LOLIMOT Poles''', ...
        'Sorry' );
end
if poles( m, 'Enable' ),
    figh = poles( m, 'Figure', p.fullname, T );
    mbH.RegisterSubFigure( figh );
else
    errordlg( ['Only ARX LOLIMOT models with non-zero feedback and ', ...
            'linear beta models support poles.'], ...
        'LOLIMOT Poles' );
end
return

%------------------------------------------------------------------------------|
function i_plottree( src, evt );
% src is the menu handle
% evt is empty
mbH = MBrowser;
p = mbH.CurrentNode;
mdev = p.info;
m = model( mdev );

if isa( m, 'xregarx' ),
    m = get( m, 'StaticModel' );
elseif ~isa( m, 'xregdynlolimot' )
    errordlg( 'Model at current node does not support ''LOLIMOT Tree plot''', ...
        'Sorry' );
end
figh = plottree( m, 'Figure', p.fullname );
mbH.RegisterSubFigure( figh );

return

%------------------------------------------------------------------------------|
function i_ViewCenters( src, evt )
% src is the menu handle
% evt is empty

mbH = MBrowser;
p = mbH.CurrentNode;
m = model( p.info );

if isa( m, 'xregarx' ),
    m = get( m, 'StaticModel' );
end
if ~isa( m, 'xregdynlolimot' ),
    errordlg( 'ViewCenters for dynamic LOLIMOT called for invalid model type', ...
        'Invalid model' );
    return
end

figh = viewcenters( m );
mbH.RegisterSubFigure( figh );

return


%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
