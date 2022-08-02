function hands= globalbuttons(m,fH,View)
% GLOBALBUTTONS   Global model buttons for XREGLOLIMOT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.6.2 $  $Date: 2004/02/09 07:50:42 $

if ishandle(fH)
    action='create';
else
    action=fH;
end

switch lower(action)
case 'id'
    hands='xreglolimot';
    
case 'toolbar'
    xregTB = get(View.toolbarBtns(1),'parent');
    [null, hands] = xregtoolbar(xregTB,...
        {'uipush', 'uipush'},...
        {'imageFile'}, {...
            'viewCenters.bmp'; 'stepwise.bmp'},...
        {'Tooltipstring'}, {...
            'View Centers'; 'Stepwise'},...
        {'clickedcallback'}, {...
            @i_ViewCenters; @i_Stepwise},...
        'transparentcolor', [0 255 0]);         
   
case 'utilities'
    uMenu = findobj(View.menus.model,'label','&Utilities');
    
    Labels = { ...
            '&View Centers'; ...
            '&Stepwise'; ...
            'LOLIMOT &Tree' };
    
    CallBacks = {...
            @i_ViewCenters; ...
            @i_Stepwise; ...
            @i_PlotTree };
    
    hands= zeros(size(Labels));
    for i=1:length(Labels)
        hands(i)= uimenu(uMenu,...
            'label',Labels{i},...
            'Callback',CallBacks{i});
    end
end

%------------------------------------------------------------------------------|
function i_Stepwise(h,evt);

mbH= MBrowser;
p= mbH.CurrentNode;
set(mbH.Figure,'pointer','watch');
drawnow
chH= mv_stepwise('create',p,0.3);
mbH.RegisterSubFigure(chH);
set(mbH.Figure,'pointer',get(0,'DefaultFigurePointer'));


%------------------------------------------------------------------------------|
function i_PlotTree(h,evt);

mbH= MBrowser;
p = mbH.CurrentNode;
set( mbH.Figure, 'pointer', 'watch' );
drawnow
figh = plottree( p.model, 'figure', p.fullname );
mbH.RegisterSubFigure( figh );
set( mbH.Figure, 'pointer', get( 0, 'DefaultFigurePointer' ) );

%------------------------------------------------------------------------------|
function i_ViewCenters( src, evt )
% src is the menu handle
% evt is empty

mbH = MBrowser;
p = mbH.CurrentNode;
m = model( p.info );

if ~isa( m, 'xreglolimot' ),
    errordlg( 'ViewCenters for LOLIMOT called for invalid model type', ...
        'Invalid model' );
    return
end

figh = viewcenters( m );
mbH.RegisterSubFigure( figh );

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

