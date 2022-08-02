function y = gaussian( r, m )
%XREGRBF/GAUSSIAN  Gaussian RBF kernel
%  GAUSSIAN(R,M) is a matrix the same size as R containing the values of 
%  the Gaussian RBF kernel at the squared and weighted distances given in R.
%
%  The Gaussian RBF kernel is given by phi(R) = exp(-R), where R is the squared 
%  and weighted distance.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:54:40 $

y = exp( -r );

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
