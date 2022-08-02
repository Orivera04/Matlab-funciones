function [y, weights] = dyneval_lolimot_linear( m, x, delmat, y0 )
%DYNEVAL_LOLIMOT_LINEAR Parallel mode for dynamic evaluation of Lolimot models
%
%  DYNEVAL_LOLIMOT_LINEAR(M,X,DELMAT,Y0) performs parallel mode dynamic
%  model evaluation for the XREGDYNLOLIMOT model M at the points X and with
%  dynamic order and delay given by DELMAT. Optional initial conditions are
%  specified by Y0.
%  [Y,W] = DYNEVAL_LOLIMOT_LINEAR(...) also returns the values of the
%  LOLIMOT weight functions in W.
%
%  See also XREGMODEL/DYNEVAL, XREGDYNLOLIMOT/DYNEVAL.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $  $Date: 2004/02/09 07:47:05 $

kernel  = getkernelstring( m );
centers = get( m, 'centers' );
width   = get( m, 'width' );
beta    = double( m );

% maximum delay indicates first output that can be calculated
md = max( sum( delmat, 1 ) );
if delmat(2,end) < 1 && delmat(1,end) ~= 0,
    error( 'Output delay must be positive' );
end

% not enough inputs to do a dynamic eval run
if md - 1 >= size( x, 1 ),
    y = repmat( NaN, size( x, 1 ), 1 );
    weights=[];
    return;
end

% set up intial condtions
if nargin > 3
    if length( y0 ) ~= md - 1,
        error( 'Initial condtion (ouput) vector is the wrong length' )
    end
else
    y0 = zeros( md - 1, 1 );
end

% convert delmat  to integers
int32Order = int32( delmat(1,:) );
int32Delay = int32( delmat(2,:) );

nStaticFactors = sum( delmat(1,:) );

% Use a mex function to perform actual evaluation
[y, weights] = dyneval_lolimot_linear_mex( ...
    lower( kernel ), ...
    transpose( centers ), ...
    transpose( width ), ...
    beta, ...
    x, ...
    int32Order, ...
    int32Delay, ...
    md, ...
    nStaticFactors, ...
    y0 );


weights = transpose( weights );

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
