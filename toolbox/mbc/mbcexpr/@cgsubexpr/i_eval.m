function out = i_eval(s)
%I_EVAL Evaluate expression
%
%  OUT = I_EVAL(s)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:15:51 $

if isempty(s)
    out = [];
else
    out = 0;
    inputs = getinputs(s);
    if s.NLeft
        lin = pveceval(inputs(1:s.NLeft),@i_eval);
        for n=1:length(lin)
            out = out + lin{n};
        end
    end
    if s.NRight
        rin = pveceval(inputs(s.NLeft+1:end),@i_eval);
        for i=1:length(rin)
            out = out - rin{i};
        end
    end    
end