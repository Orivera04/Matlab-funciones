function lab=labels(m,TeX)
% LINEARMULTIMOD/LABELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:36 $

if nargin<2
   TeX= 1;
end

lab=labels(get(m,'currentmodel'),TeX);