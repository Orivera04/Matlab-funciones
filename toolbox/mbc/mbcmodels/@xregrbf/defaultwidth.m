function [m,OK] = defaultwidth( m, X )
%DEFAULTWIDTH  Default width for an RBF
%
%  [M,OK] = DEFAULTWIDTH(M,X) sets the width in RBF model M to the deafult 
%  value for the data X. This default width is the average minimum separation 
%  of the points in X.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:30:12 $

if nargin < 2 || isempty( X )
    m.width = 1.0;   
else
    % compute the default width of the radial basis function
    N = size( X, 1 );
    
    % set a default width average min separation of points 
    m.width = mean( min( xregrbfeval( 'distance', [], X, [], [] ) ...
        + 1e16 * eye( N ), [], 2 ) );
end

OK = 1;
