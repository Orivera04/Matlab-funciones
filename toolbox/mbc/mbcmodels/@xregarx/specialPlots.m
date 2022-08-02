function out = specialplots( m, name, axh, x, y )
%XREGARX/SPECIALPLOTS  Diagnostic plots particular to dynamic ARX modeling
%   SPECIALPLOTS(M,NAME,AXH,X,Y) returns a handle to the ploted line object.
%
%   NAME can be 'Time Series', 'Time Series Residuals', 'Normal Plot'.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.6.2 $  $Date: 2004/02/09 07:45:38 $


switch name,
case 'Time Series',
    out = i_TimeSeries( m, axh, x, y, 'PrediectedObserved' );
case 'Time Series Residuals',
    out = i_TimeSeries( m, axh, x, y, 'Residuals' );
otherwise,
    yy = double( y );
    if m.DynamicOrder(end),
        % code y data
        yy = code( m.StaticModel, yy, nfactors( m.StaticModel ) );
    end
    xx = expanddata( double( x ), yy, m.DynamicOrder, m.Delay );
    out = specialPlots( m.StaticModel, name, axh, xx, yy );
    % 20 March 2002: xx and yy are ignored by SpecialPlots. 
    % - If name == 'Predicted/Obsevred' then SpecialPlots get data staright 
    %   from the model browser. 
    % - If name == 'Normal Plot' then no xx, yy data is required at all.
end
return

%------------------------------------------------------------------------------|
function out = i_TimeSeries( m, axh, x, y, action );

y0 = get( get( m, 'StaticModel' ), 'InitialConditions' );
delmat = get( m, 'OrderAndDelay' );
md = max( sum( delmat, 1 ) ) - 1;
if length( y0 ) ~= md,
    y0 = double( y(1:md) );
end

x = double( x );
y = double( y );

% make predictions
yhat = EvalModel( m, x, y0 );

% time vector
t = [ 0:length( yhat )-1 ]' / m.Frequency;
set( get( axh, 'XLabel' ), 'String', 'Time (s)' );

% Plot 
switch action,
    case 'PrediectedObserved',
        % Plot measured response
        h1 = line( 'parent', axh, ...
            'XData', t, ...
            'YData', y, ...
            'Color', 'k' );
        
        % Plot predicted response
        h2 = line( 'parent', axh, ...
            'XData', t, ...
            'YData', yhat, ...
            'Marker', 'None', ...
            'Color', 'b', ...
            'LineStyle', '-' );

        % Set y axis label
        set( get( axh, 'YLabel' ), 'String', ResponseLabel( m ) );
        
    case 'Residuals',
        % Plot residuals
        h1 = line( 'parent', axh, ...
            'XData', t, ...
            'YData', y - yhat, ...
            'Color', 'b' );
        
        % Set y axis label
        set( get( axh, 'yLabel' ), 'String', 'Residuals');
end

out = double( h1 );
return
%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
