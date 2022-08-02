function [data, str, pItems] = getweightedsolution(optim)
%GETWEIGHTEDSOLUTION Return weighted solutions
%
%  [DATA, COLHEADS, PITEMS] = GETWEIGHTEDSOLUTION(OPTIM) reutrns a matrix
%  of size (Nobjectives-by-NSolutions) which is the result of performing
%  the weighted sum over all of the operating points for each solution of
%  each objective. COLHEADS is a cell array of strings containing the names
%  for each column of data. PITEMS is a pointer vector containing the items
%  that each column corresponds to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.8.2 $    $Date: 2004/02/09 06:53:35 $ 

if ~isempty(optim.outputData)
    % Find columns of data that correxpond to objectives and multiply by
    % weights, then sum.
    [nul, idx] = ismember(optim.outputWeightsColumns, optim.outputColumns);
    data = permute(sum(repmat(optim.outputWeights, [1 1 size(optim.outputData,3)]) .* ...
        optim.outputData(:,idx, :), 1), [3 2 1]);
    pItems = optim.outputWeightsColumns;
    str = pveceval(pItems, 'getname');
else 
    data = [];
end