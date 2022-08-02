function [isinput,isoutput,isignored] = getIsFactorType(op)
%[isinput,isoutput,isignored] = getIsFactorType(op)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:47 $

if isempty(op.ptrlist)
    isinput = []; isoutput = []; isignored = [];
else
    isinput = (op.factor_type==1);
    isoutput = (op.factor_type==2);
    isignored = (op.factor_type==0);
end
