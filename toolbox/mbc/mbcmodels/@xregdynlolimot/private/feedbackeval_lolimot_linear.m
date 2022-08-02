function [y, weights] = feedbackeval_lolimot_linear( m, x, order, delay )
%XREGDYNLOLIMOT/FEEDBACKEVAL_LOLIMOT_LINEAR   Model evaluation with feedback 
%   for Lolimot models with linear betamodels.
%
%   FEEDBACKEVAL(M,X,ORDER,DELAY) evaluates the model M at the points X and 
%   with the given dynamic ORDER and DELAY. This differs from DYNEVAL in that 
%   the genuine inputs should all have been expanded and the initial conditions 
%   are correctly placed in X and it is only the output that needs to be fixed 
%   up. 
%   [Y,W] = FEEDBACKEVAL(...) also returns the values of the LOLIMOT weight 
%   functions in W.
%
%   See also XREGMODEL/FEEDBACKEVAL, XREGDYNLOLIMOT/FEEDBACKEVAL, 
%      XREGDYNLOLIMOT/DYNEVAL.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $  $Date: 2004/02/09 07:47:07 $

kernel  = getkernelstring( m );
centers = get( m, 'centers' );
width   = get( m, 'width' );
beta    = double( m );

% maximum delay indicates first output that can be calculated
md = max( order + delay );
if delay(end) < 1 & order(end) ~= 0,
    error( 'Output delay must be positive' );
end

% not enough inputs to do a dynamic eval run?
if md - 1 >= size( x, 1 ),
    y = repmat( NaN, size( x, 1 ), 1 );
    return;
end

% extract intial condtions from x
y0 = x(1:(md-1),end-order(end)+1);

% convert order and delay  to integers
int32Order = int32( order );
int32Delay = int32( delay );

% Use a mex function to perform actual evaluation
try 
    [y, weights] = feedbackeval_lolimot_linear_mex( ...
        lower( kernel ), ...
        transpose( centers ), ...
        transpose( width ).^2, ...
        beta, ...
        transpose( x ), ...
        int32Order, ...
        int32Delay, ...
        md, ...
        y0 );
catch
    error( lasterr );
end

weights = transpose( weights );

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
