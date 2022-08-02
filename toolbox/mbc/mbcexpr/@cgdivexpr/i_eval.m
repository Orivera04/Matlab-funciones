function out = i_eval(d)
%I_EVAL Evaluate expression
%
%  OUT = I_EVAL(D)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:09:41 $

if isempty(d)
    out = [];
else
    inputs = getinputs(d);
    
    if d.NTop == 0
        ti_eval = 1;
    else
        teval = pveceval(inputs(1:d.NTop),@i_eval);
        ti_eval = 1;
        for n=1:length(teval)
            ti_eval = ti_eval .* teval{n};
        end
    end
    
    if d.NBottom == 0
        bi_eval = 1;
    else
        beval = pveceval(inputs(d.NTop+1:end),@i_eval);
        bi_eval = 1;
        for n=1:length(beval)
            bi_eval = bi_eval .* beval{n};
        end
    end
    
    nz = (bi_eval~=0);
    if all(nz)
        out = ti_eval ./ bi_eval;
    else
        out = zeros(size(bi_eval));
        out(nz) = ti_eval(nz) ./ bi_eval(nz);
        out(~nz & ti_eval<0 ) = -Inf;
        out(~nz & ti_eval>0 ) = Inf;
        out(~nz & ti_eval==0 ) = NaN;
    end
end