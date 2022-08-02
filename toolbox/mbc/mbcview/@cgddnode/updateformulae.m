function [dd, ok, msg, pSym] = updateformulae(dd, pVar)
%UPDATEFORMULAE A short description of the function
%
%  [DD, OK, MSG, PSYM] = UPDATEFORMULAE(DD, PVAR) checks that the formulae
%  that use PVAR have nominal values within their ranges.  If not the range
%  is altered and the formula is rechecked for evaluation.  If the OK flag
%  is false, MSG contains the reasons for failure and PSYM contains the
%  pointer to the formula that failed.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:23:52 $ 

ok = true;
msg = {};
pSym = xregpointer;

% Check for sym values that depend on the base variable
mySym = insymval(dd,pVar);
backup_obj = cell(size(mySym));
for n = 1:length(mySym)
    % Has change forced sym setpt out of range? If so, reset range of sym
    backup_obj{n} = mySym(n).info;
    mySym(n).info = mySym(n).resetrange;
    % Check formula is still working
    [flags, msg] = checkevaluation(mySym(n).info);
    if ~all(flags)
        ok = false;
        pSym = mySym(n);
        % Revert to previous settings
        for m = n:-1:1
            mySym(m).info = backup_obj{m};
        end
        break
    end
end
