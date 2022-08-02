function y = logisticrbf( r, m )
%XREGRBF/LOGISTICRBF  Logistic RBF kernel with zero bias
%  LOGISTICRBF(R,M) is a matrix the same size as R containing the values of 
%  the logistic RBF kernel with zero bias at the squared and weighted distances 
%  given in R.
%
%  The logistic RBF kernel with zero bias is given by phi(R) = 1/(1+exp(sqrt(R))), 
%  where R is the squared and weighted distance.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:54:58 $

y = 1./(1 + exp( sqrt( r ) ) );

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
