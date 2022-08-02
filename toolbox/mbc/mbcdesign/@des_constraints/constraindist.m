function [dist] = constraindist(c, X)
%CONSTRAINDIST Evaluate distance to constraint boundary
%
%  D = CONSTRAINDIST(C,X)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:01:42 $ 

if ~isempty( X )
   dist = repmat( -Inf, size( X, 1 ), 1 );
   
   for n = 1:length( c.Constraints )
      dist = max( dist, constraindist( c.Constraints{n}, X ) );
   end
   
else
   dist = zeros( 0, 1 );
end
