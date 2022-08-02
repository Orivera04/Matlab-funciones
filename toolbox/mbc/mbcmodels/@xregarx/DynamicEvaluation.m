function figh = DynamicEvaluation(m, mdev, DataPtrs)
%XREGARX/DYNAMICEVALUATION   Evaluation of a dynamic model.
%   DYNAMICEVALUATION displays a figure and allows the user to specify different 
%   datasets and initial condtions for dynamic model evaluation.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.2 $  $Date: 2004/02/09 07:44:39 $


% Set up the figure
i_deleteold;
figh = xregfigure('tag',i_hash_fig_tag,...
    'Name', sprintf( 'Dynamic Evaluation: %s', fullname( mdev ) ),...
    'Visible', 'Off' );
    
xregcenterfigure( figh, [800, 500] ); 
figh.MinimumSize = [400, 300];
[lyt, ud] = i_CreateLayout( figh );

% Setup the two line objects for the plots
ud.response = line( ...
    'Parent', ud.axes, ...
    'Visible', 'on', ...
    'XData', [], ...
    'YData', [], ...
    'Marker', 'o', ...
    'Color', 'b', ...
    'MarkerFaceColor', 'b', ...
    'MarkerSize', 5, ...
    'LineStyle', 'None' );
ud.predictions = line( ...
    'Parent', ud.axes, ...
    'Visible', 'on', ...
    'XData', [], ...
    'YData', [], ...
    'Marker', 'None', ...
    'Color', 'k', ...
    'LineStyle', '-', ...
    'LineWidth', 4.0 );

% throw out the unsuitable data (one/two stage)
for i= 1:length( DataPtrs ),
  d = DataPtrs(i).info;
  isOneStage(i) = size( d, 1 ) == size( d, 3 );
end
ud.DataPtrs = DataPtrs(isOneStage);

%
ud.model = m;
[X, Y] = FitData( mdev );
ud.X = X;
ud.Y = Y;
ud.ResponseName = varname( mdev, 'Y' );

% Work out the max delay and hence how many initial condtions are required.
order = get( m, 'DynamicOrder' );
delay = get( m, 'delay' );
ud.MaxDelay= max( order + delay ) - 1; 

%
% Do the initial plot
ud = i_Plot( ud );

%
% Set the UserData for the figh
set( figh, 'UserData', ud );

%
% All ready, turn it on
figh.LayoutManager = lyt;
set( lyt, 'packstatus', 'on', 'visible', 'on' );
set( figh, 'visible', 'on' );

return

%------------------------------------------------------------------------------|
function ud = i_Plot( ud )
m = ud.model;
X = double( ud.X );
Y = double( ud.Y );

% generate sequence of time
t = [0:(length( Y )-1)] / get( m, 'Frequency' );

% the XData for both plots is just the time signal
set( ud.response,    'XData', t );
set( ud.predictions, 'XData', t );

% set the YData for the response
set( ud.response, 'YData', Y );

% get the initial condtions 
md = ud.MaxDelay;
y0 = get( get( m, 'StaticModel' ), 'InitialConditions' );
if length( y0 ) ~=  md,
    % set the initial condtions to be the same as the actual response
    y0 = Y(1:md);
end
ud.y0 = y0;

% generate set of predictions
yhat = EvalModel( m, X, y0 );

% set the YData of the predictions plot
set( ud.predictions, 'Ydata', yhat );

return

%------------------------------------------------------------------------------|
function varargout = i_btnDataSet( src, evt, figh )
ud = get( figh, 'UserData' );

% Get list of factor names
x_names = get( ud.X, 'name' );
yi = yinfo( ud.model );
FactorNames = unique( { x_names{:}, yi.Name } );

% Let user select sweepset
[new, ok] = gui_sweepchooser( ud.DataPtrs, 'figure', ...
    'FactorNames', FactorNames );

if ~ok, 
    return, 
elseif ok == 1, % "View model without data" radio button
    % 
end

% Need to change the plots, user data, etc, for new data
x_ind = find( new, x_names );
y_ind = find( new, yi.Name );

ud.X = new(:,x_ind);
ud.Y = new(:,y_ind);

ud = i_Plot( ud );

set( figh, 'UserData', ud );
return

%------------------------------------------------------------------------------|
function varargout = i_btnInitialConditions( src, evt, figh )
% Get new initial condtions from user.
% Reevaluate the model with these I.C.s
% Change the YData of prediction plot

ud = get( figh, 'UserData' );
m = ud.model;
X = double( ud.X );
predictions = ud.predictions;
y0          = ud.y0; % initial conditions
order = get( m, 'DynamicOrder' );
delay = get( m, 'delay' );

% Get new initial condtions from user.
y0 = GuiInitialConditions( ud.ResponseName, order, delay, y0 );
ud.y0 = y0;

% Set the model initial condtions
sm = get( m, 'StaticModel' );
sm = set( sm, 'InitialConditions', y0 );
m  = set( m, 'StaticModel', sm );
ud.model = m;

% Reevaluate the model with these I.C.s
yhat = EvalModel( m, X, y0 );

% Change the YData of prediction plot
set( predictions, 'Ydata', yhat );

set( figh, 'UserData', ud );
return

%------------------------------------------------------------------------------|
function [lyt, ud] = i_CreateLayout( figh )

% This axes will be used for ploting the time series of the measured values and 
% the model predictions
ud.axes = axes(...
    'Parent', figh,...
    'Visible', 'off', ...
    'Units', 'pixels',...
    'Box', 'on',...
    'XGrid', 'on',...
    'YGrid', 'on', ...
    'ButtonDownFcn', 'mv_zoom' );

% This layout provides a bit of a border around the axes to allow room for the 
% TickLabels.
lyt = xregborderlayout( figh, ...
    'Border', [30, 30, 5, 5], ... % [W, S, E, N]
    'Center', ud.axes );

% PushButton to set different initial condtions
btnInitialConditions = xreguicontrol( ...
    'Parent', figh, ...
    'Style', 'PushButton', ...
    'String', 'Initial Conditions', ...
    'Callback', {@i_btnInitialConditions, figh} );

% PushButton to set different data sets
btnDataSet = xreguicontrol( ...
    'Parent', figh, ...
    'Style', 'PushButton', ...
    'String', 'Data Set', ...
    'Callback', {@i_btnDataSet, figh} );

% main layout
lyt = xreggridbaglayout( figh, ...
    'Dimension', [4, 2], ...
    'RowSizes', [-1, 25, 25, 25, 25], ...
    'ColSizes', [95, -1], ...
    'GapX', 5, ...
    'GapY', 5, ...
    'Mergeblock', {[1, 4], [2, 2]}, ...
    'Elements', { ...
        [], lyt;...
        btnInitialConditions, []; ...
        btnDataSet, []; ...
        [], []} );

btnClose = uicontrol( 'Parent', figh,...
    'Style', 'PushButton',...
    'String', 'Close',...
    'Interruptible', 'off',...
    'Callback', 'delete( gcbf );' );

DividerLine = xregGui.dividerline( figh );

% Overall layout
lyt = xreggridbaglayout( figh, ...
    'Dimension',[3, 3],...
    'RowSizes',[-1, 2, 25 ],...
    'ColSizes',[-1, 65, 65],...
    'GapY',5,...
    'GapX',7,...
    'Border',[5, 5, 5, 5],...
    'MergeBlock', { [1, 1], [1, 3] }, ...
    'MergeBlock', { [2, 2], [1, 3] }, ...
    'Elements', { ...
        lyt, [], []; ...
        DividerLine, [], []; ...
        [], [], btnClose } ); 
    
return

%------------------------------------------------------------------------------|
function i_deleteold
h = findobj( allchild(0), 'flat', 'tag', i_hash_fig_tag );
if ~isempty( h )
   h = handle( h );
   delete( h );
end
return
%------------------------------------------------------------------------------|
function s = i_hash_fig_tag
s = 'XregarxDynamicEvaluation';
return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
