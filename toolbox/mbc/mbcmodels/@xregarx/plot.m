function out = plot( m, x, y , DataOK, Options, axh );
%XREGARX/PLOT - plot the predicted and observed response
%
% h= PLOT(m,X,Y,ax,BDflag,Trans,CI)
%
% Inputs
%   m        model
%   X        x data
%   Y        observed ydata
%   DataOK   logical array indicating whether data 
%   Options  [ShowBD,Trans,CI]
%   ax       axes handle
% Outputs
%   h        main data line handle

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.1 $  $Date: 2004/02/09 07:45:01 $

delmat = get( m, 'OrderAndDelay' );
md = max( sum( delmat, 1 ) ) - 1;
y0 = repmat(double(y(1)),md,1) ;

x = double( x );
y = double( y );

% make predictions
yhat = EvalModel( m, x, y0 );

% time vector
t = [ 1:length( yhat ) ]' / m.Frequency;

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
set( get( axh, 'XLabel' ), 'String', 'Time (s)' );
out = double( h1 );
return
