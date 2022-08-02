function m= UpdateParams(m,b)
% xreglinear/UPDATEPARAMS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:12 $

m2= UpdateParams(get(m,'currentmodel'),b);
set(m,'currentmodel',m2);