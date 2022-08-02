function hands = globalbuttons( m, action, varargin )
%XREGARX/GLOBALBUTTONS   Global model buttons for XREGARX
%   GLOBALBUTTONS(M,FIGH) 
%   GLOBALBUTTONS(M,'ID') 
%   GLOBALBUTTONS(M,'Toolbar') toolbar buttons
%   GLOBALBUTTONS(M,'Utilities') menu items

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.6.2 $  $Date: 2004/04/04 03:29:49 $

StaticHands = globalbuttons( get( m, 'StaticModel' ), action, varargin{:} );

if ishandle( action )
    figh = action;
    action = 'create';
end

switch lower( action )
    case 'create'
        % hands = {};
        hands = StaticHands;
        
    case 'id'
        % hands = 'xregarx';
        hands = sprintf( 'xregarx/%s', StaticHands );
        
    case 'toolbar'
        View = varargin{1};
        Toolbar = get( View.toolbarBtns(1), 'Parent' );
        
        [null, newHands] = xregtoolbar( Toolbar, {'uipush'},...
            'ImageFile', 'refresh.bmp',...
            'Tooltipstring', 'Update Model Fit',...
            'ClickedCallback', @i_refit,...
            'TransparentColor', [0 255 0]);
        
        hands = [newHands(:); StaticHands(:)];
        
    case 'utilities'
        View = varargin{1};
        uMenu = findobj( View.menus.model, 'label', '&Utilities' );
        
        hands(1) = uimenu( uMenu,...
            'label', '&Update Model Fit',...
            'Callback', @i_refit );
        
        hands(2) = uimenu( uMenu,...
            'label', '&Dynamic Evaluation',...
            'Callback', @i_DynamicEvaluation );
        
        hands = [ hands(:); StaticHands(:) ];
end

return

%------------------------------------------------------------------------------|
function i_refit( src ,evt );
% src is the menu handle
% evt is empty

mbh = MBrowser;
p = get(mbh,'CurrentNode');
set( mbh.Figure, 'pointer', 'watch' );
p.refit;
mbh.ViewNode;
set( mbh.Figure, 'pointer', get( 0, 'DefaultFigurePointer' ) );

return

%------------------------------------------------------------------------------|
function i_DynamicEvaluation(src, evt)

% Get the pointers to the model browser
mbh = MBrowser;

% Get the model development object and model from model browser
mdev = mbh.CurrentNode.info;
m = model( mdev );
if ~isa( m, 'xregarx' ),
    errordlg( 'Dynamic evaluation only avaliable for Dynamic ARX models.', ...
        'Dynamic Evaluation Unavailable' )
end

% Get the candidate validation data sets from the project pointer 
% This returns an array of pointers to sweepsets
DataPtrs = mbh.RootNode.dataptrs;

figh = DynamicEvaluation(m, mdev, DataPtrs);
mbh.RegisterSubFigure( figh );

return;

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
