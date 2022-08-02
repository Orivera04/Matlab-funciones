function cvals = ceval(mod)
%CEVAL Evaluate constraints
%
%  DATA = CEVAL(M)
%    DATA<0 is feasible

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:12:54 $

if isempty(mod)
    cvals= [];
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
    cvals = ceval(mod.model, inputs); 
end