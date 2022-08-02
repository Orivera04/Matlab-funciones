function y = eval( m, X )
%EVAL Evalution of an RBF model
%
%  Y = EVAL(M,X) is a vector of values of the RBF model M at the points given 
%  in X (one row for each point).
%
%  See also XREGRBF.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.4 $  $Date: 2004/04/04 03:30:13 $

if isempty( X ) || isempty( m.centers )
    y = zeros( size( X, 1 ), 1 );
else
    y = xregrbfeval( getkernelstring( m ), X, m.centers, m.width, double( m ) );
end
