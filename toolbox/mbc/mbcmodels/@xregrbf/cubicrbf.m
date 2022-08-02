function y = cubicrbf( r, m )
%XREGRBF/CUBICRBF  Cubic RBF kernel
%  CUBICRBF(R,M) is a matrix the same size as R containing the values of 
%  the cubic RBF kernel at the squared and weighted distances given in R.
%
%  The cubic RBF kernel is given by phi(R) = sqrt(R)^3, where R is the squared 
%  and weighted distance.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

y = sqrt( r ).^3;

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
