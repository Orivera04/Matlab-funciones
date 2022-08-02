function str = name( m )
%NAME   Consise name of an xreginterprbf object.
%   NAME(M) is a compact name that describes the interpolating rbf M.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:48:51 $ 



str = sprintf( 'Interpolating-%s', get(m, 'kernel') );

% EOF
