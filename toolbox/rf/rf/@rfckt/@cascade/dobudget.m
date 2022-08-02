function dobudget(h)
%DOBUDGET Set the flag for budget analysis.
%   DOBUDGET(H) sets the flag for budget analysis.

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2004/03/30 13:10:46 $

%Set the flag for budget analysis.
setflagindexes(h);
updateflag(h, indexOfTheBudgetAnalysisOn, 1, MaxNumberOfFlags);
updateflag(h, indexOfNeedToUpdate, 1, MaxNumberOfFlags);