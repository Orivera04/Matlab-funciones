function y = linearrbf( r, m )
%XREGRBF/LINEARRBF  Linear RBF kernel
%  LINEARRBF(R,M) is a matrix the same size as R containing the values of 
%  the linear RBF kernel at the squared and weighted distances given in R.
%
%  The linear RBF kernel is given by phi(R) = sqrt(R), where R is the squared 
%  and weighted distance.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

y = sqrt( r );

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
