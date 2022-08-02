%MX_RBFEVAL Weighted interpoint distances, X2FX, evaluation of RBFs
%
%  MX_RBFEVAL(KERNEL,X,Y,W,BETA)
%
%  KERNEL must a lower case string
%  X, Y should be (number of dims-by-number of points)
%  X has the role or evaluation points, can be [] to use X=Y
%  Y has the role of RBF centers
%  W should be (1-by-1)
%              (number of dims-by-1)
%              (1-by-number of points in Y)
%           or (number of dims-by-number of points in Y)
%  If W is the width of an RBF, then W'.^2 should be passed in
%  BETA should be number of points (in Y) long
%
%  The output is the matrix of interpoint kernel values if beta is empty or
%  a  vector of weighted sums (RBF evaluations) if beta is not empty
%
%  Example use: (m is an XREGRBF model)
%
%  mx_distancepoints( X, Y ) becomes
%      MX_RBFEVAL( 'distance', Y', X', [], [] )
%
%  To computes the weighted interpoint distances use
%      MX_RBFEVAL( 'distance', Y', X', W.^2, [] ) 
%
%  x2fx( m, X ) becomes 
%      MX_RBFEVAL( kernel, X', m.centers', m.width'.^2, [] )
%
%  x2fx( m ) becomes 
%      MX_RBFEVAL( kernel, [], m.centers', m.width'.^2, [] )
%
%  eval( m, X ) becomes 
%      MX_RBFEVAL( kernel, X', m.centers', m.width'.^2, double( m ) )
%
%  The kernel name passed to MX_RBFEVAL is constructed as:
%
%      kernel = lower( func2str( m.kernel ) );
%      if strcmp( 'wendland', kernel ),
%          kernel = sprintf( '%s%d', kernel, m.cont );
%      end
%
%  This code is the function XREGRBF/GETKERNELSTRING.
%
%  See also XREGRBF, XREGRBF/GETKERNELSTRING.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $  $Date: 2004/04/04 03:30:59 $
