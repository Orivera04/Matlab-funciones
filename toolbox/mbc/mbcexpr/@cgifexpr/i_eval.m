function output = i_eval(ifexp)
%I_EVAL  Evaluate expression
%
%  OUT = I_EVAL(IFEXPR)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:12 $

if isempty(ifexp)
    output = [];
else
    inputs = getinputs(ifexp);
    leftswitch = inputs(1).i_eval;
    rightswitch = inputs(2).i_eval;    
    outswitch = (leftswitch < rightswitch);
    if length(outswitch)==1
        % Take all of one of the inputs
        if outswitch
            output = inputs(3).i_eval;
        else
            output = inputs(4).i_eval;
        end
    else
        if all(outswitch)
            % All input one
            output = inputs(3).i_eval;
        elseif ~any(outswitch)
            % All input two
            output = inputs(4).i_eval;
        else
            % Need to evaluate  both inputs
            output = zeros(length(outswitch),1);
            tmp = inputs(3).i_eval;
            if length(tmp)>1
                output(outswitch) = tmp(outswitch);
            else
                output(outswitch) = tmp;
            end
            outswitch = ~outswitch;
            tmp = inputs(4).i_eval;
            if length(tmp)>1
                output(outswitch) = tmp(outswitch);
            else
                output(outswitch) = tmp;
            end
        end
    end
end