function [flags, msg] = checkevaluation(obj)
%CHECKEVALUATION Check that the formula can be evaluated
%
%  [FLAGS, MSG] = CHECKEVALUATION(OBJ) perfoms a series of evaluation tests
%  on the formula object and returns a vector of flags to indicate the
%  return status of each one.  MSG is a cell array of message strings
%  describing the problems encountered.  Where possible, the checking will
%  still continue to other tests if an earlier one fails.
%
%  The FLAGS output is a boolean vector where a false entry means that the
%  formula object failed that test.  The entries correspond to the following
%  tests:
%
%  1. Formula failed to evaluate
%  2. Formula is real over the input range
%  3. Formula is finite over the input range
%  4. Inverse of formula failed to evaluate
%  5. Inverse of formula is real over the formula range
%  6. Inverse of formula is finite over the formula range

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:15:24 $ 

msg = {};
flags = true(1,6);

Nsamples = 100;
pVal = obj.EquationPointers(obj.EquationVariableIndex);

% Formula checks
pVal.info = pVal.linspace(100);
try
    vals = getvalue(obj);
catch
    flags(1) = false;
    msg = [msg; {'Unable to evaluate formula'}];
end

if flags(1)
    % also check the nominal value and zero
    pVal.info = pVal.setpoint;
    vals = [vals; getvalue(obj)];
    rng = pVal.getrange;
    if rng(1)<0 && rng(2)>0
        pVal.info = pVal.setvalue(0);
        vals = [vals; getvalue(obj)];
    end
    flags(2) = all(isreal(vals));
    flags(3) = all(isfinite(vals));
    if ~flags(2)
        msg = [msg; {'Formula returns complex values'}];
    end
    if ~flags(3)
        msg = [msg; {'Formula returns non-finite values'}];
    end
end

% Inverse checks
try
    obj = linspace(obj, 100);
    vals = pVal.getvalue;
catch
    flags(4) = false;
    msg = [msg; {'Unable to evaluate inverse of formula'}];
end

if flags(4)
    % also check the nominal value and zero
    setpoint(obj);
    vals = [vals; pVal.getvalue];
    rng = getrange(obj);
    if rng(1)<0 && rng(2)>0
        setvalue(obj, 0);
        vals = [vals; pVal.getvalue];
    end
    flags(5) = all(isreal(vals));
    flags(6) = all(isfinite(vals));
    if ~flags(5)
        msg = [msg; {'Inverse formula returns complex values'}];
    end
    if ~flags(6)
        msg = [msg; {'Inverse formula returns non-finite values'}];
    end
end