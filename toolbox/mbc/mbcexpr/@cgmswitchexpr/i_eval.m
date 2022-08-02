function out = i_eval(m)
%I_EVAL Evaluate expression
%
%  OUT = I_EVAL(M)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:34 $

if isempty(m)
    out = [];
else
    inputs = getinputs(m);
    
    % Evaluate switching input
    switchval = round(inputs(1).i_eval);
    
    % The switch values must be in the range 1..length(inputs).  Any values
    % outside this range will produce a NaN output
    
    listlen = length(inputs)-1;
    if length(switchval)==1
        if switchval>=1 && switchval<=listlen
            out = inputs(switchval+1).i_eval;
        else
            out = NaN;
        end
    else
        out = repmat(NaN, size(switchval));
        for n = 1:listlen
            matched = (switchval==n);
            if any(matched)
                invalue = inputs(n+1).i_eval;
                if length(invalue)>1
                    out(matched) = invalue(matched);
                else
                    out(matched) = invalue;
                end
            end
        end
    end
end