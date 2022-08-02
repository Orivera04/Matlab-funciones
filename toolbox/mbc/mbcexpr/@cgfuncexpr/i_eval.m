function out = i_eval(f)
%I_EVAL Evaluate expression
%
%  OUT = I_EVAL(F)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:01 $

if isempty(f)
    out = [];
else
    inputs = getinputs(f);
    % Check that there are enough inputs for the model
    num_inputs = length(inputs);
    
    % Generate the inputs for the function
    if num_inputs>0
        inp = pveceval(inputs,@i_eval);
    else
        inp ={};
    end
    
    % Evaluate function model
    Xg = zeros(max(cellfun('length',inp)),num_inputs);
    for i = 1:num_inputs
        Xg(:,i)= inp{i}(:);
    end
    out = eval(f.function,Xg); 
end