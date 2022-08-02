function exp=revertRanges(exp)
%Reverts the Upper and Lower validity ranges to the defaults stored in the eportmodel.model.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:47:42 $
[exp.LowerRange,exp.UpperRange]=range(exp.model);
