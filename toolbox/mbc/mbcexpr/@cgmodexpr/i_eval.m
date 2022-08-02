function data = i_eval(mod)
%I_EVAL Evaluate expression
%
%  DATA = I_EVAL(M)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.3 $  $Date: 2004/02/09 07:13:13 $

msg = {};
if isempty(mod)
    data = [];
else
    % Generate the inputs for the function.
    inp = getinputs(mod);
    if all(isvalid(inp))
        inputs = pveceval(inp,@i_eval);
        num_inputs = length(inputs);
    else
        error('mbc:cgmodexpr:InvalidState', 'Some of the input expression pointers are invalid.');
    end 
    
    % Evaluate model
    mdl = mod.model;
    data = EvalModel(mdl,inputs);
    data(~isnan(data)) = min(max(data(~isnan(data)), mod.clips(1)), mod.clips(2));  
end