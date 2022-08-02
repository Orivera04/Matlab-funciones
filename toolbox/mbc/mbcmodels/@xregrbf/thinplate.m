function y = thinplate( r, m )
%XREGRBF/THINPLATE  Thin-plate spline RBF kernel
%  THINPLATE(R,M) is a matrix the same size as R containing the values of the 
%  thin-plate spline RBF kernel at the squared and weighted distances given in R.
%
%  The thin-plate spline kernel is given by phi(R) = 0.5*R*log(R), where R is 
%  the squared and weighted distance.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.6.2.2 $  $Date: 2004/02/09 07:57:27 $

y = zeros( size( r ) );
ind = find( r > eps );
r = r(ind);

if ~isempty( r ),
    y(ind) = 0.5 * r .* log( r );
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
