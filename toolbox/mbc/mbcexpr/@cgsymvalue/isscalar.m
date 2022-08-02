function out = isscalar(v)
%ISSCALAR Check if variable is a scalar
%
%  OUT = ISSCALAR(VAL) returns true if VAl contains a scalar value.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:15:36 $ 

out = (length(getvalue(v))==1);