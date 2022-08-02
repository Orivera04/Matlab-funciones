function out = cond( m )
%CONDEST   1-norm condition number estimate for XREGINTERPRBF 
%   CONDEST(M) computes a lower bound for the 1-norm condition number of 
%   the interpolation matrix associated with the XREGINTERPRBF object M. 
%   Large condition numbers indicate a nearly singular matrix and hence 
%   an unstable estimate of the coefficients.
%   
%   See also COND.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:48:41 $ 

error( nargchk( 1, 1, nargin ) ); 

centers = get( m, 'centers' );
ncenters = size( centers, 1 );

FX = CalcJacob( m, centers );

poly_dim = size(FX,2) - ncenters; % dimension of polynomial space

if poly_dim > 0,
    P = FX(:,1:poly_dim);
    out = condest( [ FX; P', zeros( poly_dim ) ] );
else 
    out = condest( FX );
end

% EOF
