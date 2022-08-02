function sys = ConstraintEval(m,parentsys,des)
%CONSTRAINTEVAL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:02 $

sys = slconstraints(des,parentsys);
