function y = recmultiquadric( r, m )
%XREGRBF/RECMULTIQUADRIC  Reciprocal multiquadric RBF kernel
%  RECMULTIQUADRIC(R,M) is a matrix the same size as R containing the values of 
%  the reciprocal multiquadric RBF kernel for the model M at the squared and 
%  weighted distances given in R.
%
%  Note that the definition of the reciprocal multiquadric kernel is slightly 
%  different if the model has a global width or width/center rather than a 
%  width/dimension or width/center/dimension. In either of the last two cases, 
%  the kernel is phi(R) = 1/sqrt(R+1), where the width has already been taken 
%  care of in the squared distance R. However, in the other two cases, 
%  phi(R) = 1/sqrt(R+W^2), where now R is the sqaured distance without the 
%  width W. In all four cases, the squared and weighted distances should be 
%  passed into this function.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:57:13 $

if numel( m.width ) == 1 ,
    y = 1.0./( abs( m.width )*sqrt( r + 1.0 ) ); 
elseif size( m.width, 2 ) == 1,
    % when each center has its own width 
    y = zeros( size( r ) );
    for i = 1:size( r, 2 )
        y(:,i) = 1.0./( abs( m.width(i) ) * sqrt( r(:,i) + 1.0 ) );
    end   
else
    y = 1.0./sqrt( r + 1.0 ); 
end    

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
