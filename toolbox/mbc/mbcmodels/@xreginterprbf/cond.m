function out = cond( m, p )
%COND   Condition number of XREGINTERPRBF interpolation matrix
%   COND(M) returns the 2-norm condition number of the interpolation matrix
%   associated with the XREGINTERPRBF object M. Large condition numbers 
%   indicate a nearly singular matrix and hence an unstable estimate of the
%   coefficients.
%   
%   COND(M,P) returns the condition number of M in P-norm.
%
%   See also: COND

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:48:40 $ 

if nargin < 2,
    p = 2;
end

centers = get( m, 'centers' );
ncenters = size( centers, 1 );

FX = CalcJacob( m, centers );

poly_dim = size(FX,2) - ncenters; % dimension of polynomial space

if poly_dim > 0,
    P = FX(:,1:poly_dim);
    out = cond( [ FX; P', zeros( poly_dim ) ], p );
else 
    out = cond( FX, p );
end

% EOF
