function out = peveval(thing)
%PEVEVAL Evaluate pev
%
%  Y = PEVEVAL(EXPR) evaluates PEV for the expresssion EXPR.  If PEV is not
%  supported, this method will return a scalar NaN.
%
%  See also: CGEXPR/PEVCHECK, CGEXPR/EVALUATE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.4.2 $  $Date: 2004/02/09 07:13:24 $

if isempty(thing)
    out = [];
else
    if pevcheck(thing.model)
        exprlist = getinputs(thing);
        mod = thing.model;
        inputs = pveceval(exprlist, 'i_eval');
        out_len = max(cellfun('length',inputs));
        Xg = zeros(out_len, length(inputs));
        for n=1:length(inputs)
            Xg(:,n)= inputs{n}(:);
        end   
        out = pev(mod,Xg,1);
    else
        out = NaN;
    end
end