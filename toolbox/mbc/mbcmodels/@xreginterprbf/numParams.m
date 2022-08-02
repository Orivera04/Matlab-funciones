function n = numparams( m )
%NUMPARAMS   Number of parameters of an xreginterprbf object
%   NUMPARAMS(M) is the number of independent parameters in the 
%   xreginterprbf object M. This possibly differs from the number of 
%   coefficients because the coefficients of the rbf part must orthogonal 
%   to polynomials in the space that the polynomial part (linearmodpart) 
%   are chosen from.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 07:48:52 $ 


nargchk( 1, 1, nargin );

n = numParams( get( m, 'rbfpart' ) );

% EOF
