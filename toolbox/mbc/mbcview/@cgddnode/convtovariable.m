function [ok, msg] = convtovariable(dd, pVar)
%CONVTOVARIABLE Convert item to a variable
%
%  [OK, MSG] = CONVTOVARIABLE(DD, PITEM)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:23:11 $ 

ok = false;
msg = '';
if pVar.issymvalue || pVar.isconstant
    mySym = insymval(dd, pVar);
    if isempty(mySym)
        oldobj = pVar.info;
        val = cgvalue;
        val = copybaseinfo(oldobj, val);
        if issymvalue(oldobj)
            val = setrange(val, getrange(oldobj));
            pDD = address(dd);
            dd = pDD.info;
            dd.numsymvars = dd.numsymvars - 1;
            pointer(dd);
        else
            val = setrange(val, [0 2*getnomvalue(val)]);
        end
        pVar.info = val;
        ok = true;
    else
        msg = 'Unable to convert to variable because the item is currently being used by a formula.';
    end
else
    % No work to do
    ok = true;
end