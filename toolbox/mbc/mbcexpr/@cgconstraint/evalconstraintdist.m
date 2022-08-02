function y=evalconstraintdist(obj)
%EVALCONSTRAINTDIST Evaluate distance from constraints
%
%  OUT = EVALCONSTRAINTDIST(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.6.2 $    $Date: 2004/04/04 03:27:20 $

inputcell = pveceval(getinputs(obj),@i_eval);
inputs = zeros(max(cellfun('length',inputcell)),length(inputcell));
for n = 1:length(inputcell)
    inputs(:,n) = inputcell{n}(:);
end  
if ~isempty(obj.conobj)
    y = constraindist(obj.conobj, inputs);
else
    y = zeros(size(inputs,1),1);
end
