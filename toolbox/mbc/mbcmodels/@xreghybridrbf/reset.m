function m= reset(m);
% XREGHYBRIDRBF/RESET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:48:19 $

m= set(m,'fitalg','hybridrbffit');
m.linearmodpart= reset(m.linearmodpart);
m.rbfpart      = reset(m.rbfpart);
m.xreglinear   = reset(m.xreglinear);