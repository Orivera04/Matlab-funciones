function y = wendland( r, m )
%XREGRBF/WENDLAND  Wendland's compactly supported RBF kernel
%  WENDLAND(R,M) is a matrix the same size as R containing the values of the 
%  Wendland RBF kernel for the for model M at the squared and weighted 
%  distances given in R.
%
%  Wendland's compactly supported kernels are given in 'Radial Basis Functions 
%  with Compactly Support (sic.) and Multizone Decomposition: Applications to 
%  environmental modelling', S. M. Wong, Y.C. Hon, and T.S. Li.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:57:32 $

% Rewritten 12/2/2001 to use the general formulae given in 'Radial Basis 
% Functions with Compactly Support (sic.) and Multizone Decomposition: 
% Applications to environmental modelling', S. M. Wong, Y.C. Hon, and T.S. Li, 
% and to include continuity = 6, and remove the restriction on the space 
% dimension.

[exponent, polycoeff] = wendcoeff( m );

y = zeros( size( r ) );

ind = find( r < 1 );
r = sqrt( r(ind) );
r = r(:);

if ~isempty( r ),
    y(ind) = (1-r).^(exponent) .* polyval_mex( polycoeff, r );
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
