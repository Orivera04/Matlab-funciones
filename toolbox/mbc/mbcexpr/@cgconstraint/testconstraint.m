function y = testconstraint(obj)
%TESTCONSTRAINT Evaluate constraint
%
%  Y = TESTCONSTRAINT(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.2 $    $Date: 2004/04/04 03:27:22 $

inputcell = pveceval(getinputs(obj), @i_eval);
inputs = zeros(max(cellfun('length',inputcell)),length(inputcell));
for n = 1:length(inputs)
    inputs(:,n) = inputcell{n}(:);
end  
in = true(size(inputs,1),1);
if ~isempty(obj.conobj)
    y = constrain(obj.conobj, inputs, in);
else
    y = in;
end