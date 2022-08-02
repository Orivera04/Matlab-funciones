function a=alias(m)
%xreglinear/ALIAS   Alias matrix
%   Returns alias matrix for m and coded design matrix X
%   This function expects data to be in m.store.  Use initstore
%   first to set this up

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:13 $

a=alias(get(m,'currentmodel'));