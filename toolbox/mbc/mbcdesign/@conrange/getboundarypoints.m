function [c, bp] = getboundarypoints( c, X )
%GETBOUNDARYPOINTS A short description of the function
%
%  [C, BP] = GETBOUNDARYPOINTS(C,X)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/02/09 06:58:44 $ 

[a, i] = min( X, [], 1 );
[b, j] = max( X, [], 1 );

bp = unique( [i(:); j(:)] );
