function [obj, OK] = createExtrapolationMaskFromBoundary(obj, expr)
%CREATEEXTRAPOLATIONMASKFROMBOUNDARY Generate an extrapolation mask from a boundary
%
%  [OBJ, OK] = CREATEEXTRAPOLATIONMASKFROMBOUNDARY(OBJ, EXPRESSION)
%  generates a new extrapoltion mask from the boundary constraint of the
%  cgexpr subclass EXPRESSION.  Cells that have input values that are
%  within the boundary constraint will be in the mask.
%  If EXPRESSION does not support boundary evaluation, or if the table
%  cannot identify a single variable input for each axis the flag OK will
%  be set to be false.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:10:10 $ 

OK = concheck(expr) && hasinportperaxis(obj);
if OK
    % Set up table inports so that they match the table breakpoints
    OK = setinportsforcells(obj);
    if ~OK
        return
    end
    % Set up the remaining expression inputs to their nominal values
    pExprVar = getinports(expr);
    pTblVar = getinports(obj);
    if length(pTblVar)>1
        pTblVar([1 2]) = pTblVar([2 1]);
    end
    ToNomValues = cgisindependentvars(pExprVar, pTblVar);
    passign(pExprVar(ToNomValues), pveceval(pExprVar(ToNomValues), @setpoint));
    
    % Evaluate expression over the table cells and threshold it to get a
    % new mask
    dBdry = evaluategrid(expr, pTblVar, 'constraint');
    obj = pSetExtrapolationMask(obj,(dBdry<=0));
end