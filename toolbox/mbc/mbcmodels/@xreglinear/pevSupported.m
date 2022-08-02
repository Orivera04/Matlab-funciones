function out = pevSupported(m)
%xreglinear/PEVSUPPORTED overloaded method for twostage models

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:53 $


% All linearmods support PEV. However localmods do not support PEV
out = ~isa(m,'localmod');
