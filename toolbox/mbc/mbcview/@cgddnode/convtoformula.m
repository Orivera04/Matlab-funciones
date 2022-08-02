function [ok, msg] = convtoformula(dd, pVar, rhsStr)
%CONVTOFORMULA Convert item to a formula
%
%  [OK, MSG] = CONVTOFORMULA(DD, PITEM)
%  
%  [OK, MSG] = CONVTOFORMULA(DD, PITEM, NEWRHS )

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.4.3 $    $Date: 2004/02/09 08:23:10 $ 

ok = false;
msg = '';
if ~pVar.issymvalue
    mySym = insymval(dd, pVar);
    if isempty(mySym)
        oldobj = pVar.info;
        SV = cgsymvalue;
        SV = copybaseinfo(oldobj, SV);
        if ~isconstant(oldobj)
            SV = setrange(SV, getrange(oldobj));
        end
        pDD = address(dd);

        if nargin==2
            [SV, ok] = editequation(SV, pDD, pVar.getname );
        elseif nargin==3 && ischar( rhsStr )
            [SV, flags] = setequation( SV, rhsStr, pDD );
            SV = updaterange( SV );
            ok = all(flags);
        end

        if ok
            pVar.info = SV;
            dd = pDD.info;
            dd.numsymvars = dd.numsymvars + 1;
            pointer(dd);
        end
    else
        msg = 'Unable to convert to formula because the item is currently being used by another formula.';
    end
else
    % No work to do
    ok = true;
end
    