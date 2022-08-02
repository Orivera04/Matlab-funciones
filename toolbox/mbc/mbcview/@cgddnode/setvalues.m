function ok = setvalues(dd, pInputs, vals, pOther)
%SETVALUES A short description of the function
%
%  OK = SETVALUES(DD, PINPUTS, VALS, POTHER) sets each item in the pointer
%  list PINPUTS to have the value in the corresponding cell array  VALS.
%  If POTHER is also supplied, these items are set to their nominal values,
%  so long as they have not been implicitly set by the values of pIINPUTS
%  being set.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:23:49 $ 

ok = false;
if cgisindependentvars(pInputs)
    % set any nominal values first; this allows for altering of constant
    % values before formulae are set
    if nargin>3
        for k = 1:length(pOther)
            if isempty(finddeps(dd, pOther(k), pInputs))
               pOther(k).info = pOther(k).setpoint; 
            end
        end
    end
    for k = 1:length(vals)
        pInputs(k).info = pInputs(k).setvalue(vals{k});
    end
    ok = true;
end