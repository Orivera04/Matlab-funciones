function [ data, labels, specialPlots, olIndex ] = diagnosticstats( m, x, y )
%XREGARX/DIAGNOSTICSTATS   Diagnostic statistics for dynamic ARX models
%   DIAGNOSTICSTATS(M,X,Y) returns the diagnostic statistics for the static 
%   model embedded in the dynamic ARX model M. The inputs X and outputs Y are 
%   suitably shifted before they are passed to the static model.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:44:49 $


% Cheap easy version - uses series-parallel eval
%% xx = expanddata( x, y, m.DynamicOrder, m.Delay );
%% [data, labels, specialPlots, olIndex ] = diagnosticStats( m.StaticModel, xx, y );



delmat = get( m, 'OrderAndDelay' );
md = max( sum( delmat, 1 ) ) - 1;
sm= get( m, 'StaticModel' );


if isa(x,'sweepset') & size(x,1)>size(x,3)
    sm= get( m, 'StaticModel' );
    yhat= cell(1,size(x,3));
    for i= 1:size(x,3)
        yd=  y{i};
        y0 = repmat(yd(1),md,1) ;   
        set( sm, 'InitialConditions' ,y0);
        set( m, 'StaticModel', sm);
        yhat{i} = EvalModel( m, x{i} );
    end
    yhat= cat(1,yhat{:});
else
    yhat = EvalModel( m, x );
end


x = double( x );
y = double ( y );

% data and labels
inputs = InputLabels( m );
output = ResponseLabel( m );
obs = [ 1:length( y ) ]';
data = [ obs, y, yhat, y-yhat, x ];
labels = { ...
        'Obs. Number', ...
        output, ...
        sprintf( 'Predicted %s', output ), ...
        'Residuals', ...
        inputs{:} };

% Available special plots
specialPlots = { ...
        'Time Series', ...           % time vs actual and model response
        'Time Series Residuals', ... % time vs residual
        'Normal Plot' };             % inherited from embedded statis model

% Outlier index - no outliesr for dynamic models
olIndex = [];

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
