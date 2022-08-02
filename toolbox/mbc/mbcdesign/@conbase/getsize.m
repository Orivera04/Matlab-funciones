function sz=getsize(c)
%GETSIZE   Return current number of factors
%  SZ = GETSIZE(C)  returns the current number of factors
%  that C is set to work with.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:57:04 $ 

sz = size( c.Variables, 2 );

% EOF
