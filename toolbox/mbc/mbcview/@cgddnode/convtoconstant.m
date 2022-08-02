function [ok, msg] = convtoconstant(dd, pVar)
%CONVTOCONSTANT Convert item to a constant
%
%  [OK, MSG] = CONVTOCONSTANT(DD, PITEM)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:23:09 $ 

ok = false;
msg = '';
if ~pVar.isconstant
    mySym = insymval(dd, pVar);
    if isempty(mySym)
        oldobj = pVar.info;
        const = cgconstvalue;
        const = copybaseinfo(oldobj, const);
        const = setpoint(const);
        pVar.info = const;
        if issymvalue(oldobj)
            dd.numsymvars = dd.numsymvars - 1;
            pointer(dd);
        end
        ok = true;
    else
        msg = 'Unable to convert to constant because the item is currently being used by a formula.';
    end
else
    % No work to do
    ok = true;
end
