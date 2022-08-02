function out = pevSupported(m)
%xreglinear/PEVSUPPORTED overloaded method for twostage models

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:46 $

out = pevSupported(get(m,'currentmodel'));