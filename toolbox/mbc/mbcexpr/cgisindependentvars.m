function [ret, pLinked] = cgisindependentvars(pToCheck, pVars)
%CGISINDEPENDENTVARS Check if variables are independent
%
%  All parameters are arrays of pointers to cgvariables.
%
%  RET = CGISINDEPENDENTVARS(PVARS) returns a logical, which is true if
%  all variables in PVARS are independent.  Otherwise (i.e. if any entry
%  is a formula which depends on other entries in PVARS), it returns false.
%
%  RET = CGISINDEPENDENTVARS(PTOCHECK, PVARS) returns a logical array which
%  contains true for each entry in PTOCHECK which is independent of all the
%  entries in PVARS, and false for the others.  Note that calls to this
%  form of the function may not be symmetric, that is CGISINDPENDENTVARS(A,
%  B) may not be the same as CGISINDEPENDENTVARS(B, A).  This is true in
%  particular for links between formulae and constants and occurs because
%  of the fact that changing a formula cill not alter a constant, but
%  changing a constant my alter a formula.
%
%  [RET, PLINKED] = CGISINDEPENDENTVARS(...) also returns the first pointer
%  that was found to be causing a link with another.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.8.3 $    $Date: 2004/02/09 07:17:09 $ 

ret = true;
if nargin==1
    if length(pToCheck)<2
        % 0/1 variables being checked => they must be independent
        ret = true;
        if nargout>1
            pLinked = null(xregpointer, 0);
        end
        return
    end
    
    objToCheck = info(pToCheck);
    
    
    for n = 1:numel(double(pToCheck))
        if issymvalue(objToCheck{n})
            % Look for an overlap with inputs and pToCkeck
            ret = ~anymember(getrhsptrs(objToCheck{n}), pToCheck);
            if ~ret
                if nargout>1
                    pLinked = intersect(getrhsptrs(objToCheck{n}), pToCheck);
                    pLinked = pLinked(1);
                end
                break
            else
                % Replace pointer in pToCheck with the input pointer, to
                % catch two formulae with common inputs
                pToCheck(n) = getvariable(objToCheck{n});
            end
        end
    end
    
    if ret && nargout>1
        pLinked = null(xregpointer, 0);
    end
    
else
    % First expand any symvalues in pVars
    bSyms = pveceval(pVars, @issymvalue);
    bSyms = [bSyms{:}];
    if nargout<2
        if any(bSyms)
            pAllVars = pveceval(pVars(bSyms), @getvariable);
            pAllVars = unique([pAllVars{:}, pVars(:)']);
        else
            pAllVars = unique(pVars(:)');
        end
        ret = true(size(pToCheck));

        objToCheck = infoarray(pToCheck);
        for n = 1:numel(double(pToCheck))
            if issymvalue(objToCheck{n})
                ret(n) = ~(any(pToCheck(n)==pAllVars) || ...
                    anymember(getrhsptrs(objToCheck{n}), pAllVars));
            else
                ret(n) = ~any(pToCheck(n)==pAllVars);
            end
        end
    else
        % Alternative algorithm is slower but produces the links as well
        pAllVars = cell(1, length(pVars));
        if any(bSyms)
            pAllVars(bSyms) = pveceval(pVars(bSyms), @getvariable);
        end
        ret = true(size(pToCheck));
        pLinked = null(xregpointer, size(ret));
        
        objToCheck = infoarray(pToCheck);
        for n = 1:numel(double(pToCheck))
            if issymvalue(objToCheck{n})
                checkptr = [pToCheck(n), getrhsptrs(objToCheck{n})];
            else
                checkptr = pToCheck(n);
            end
            
            for m = 1:length(pVars)
                if any(checkptr==pVars(m)) ...
                        || (~isempty(pAllVars{m}) && any(checkptr==pAllVars{m})) ...
                    ret(n) = false;
                    pLinked(n) = pVars(m);
                    break
                end
            end
        end
    end
end
