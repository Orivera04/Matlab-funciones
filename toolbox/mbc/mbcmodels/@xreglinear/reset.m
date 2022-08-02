function m= reset(m);
% XREGLINEAR/RESET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:50:05 $

% include all terms in model
m= IncludeAll(m);
m.xregmodel= reset(m.xregmodel);