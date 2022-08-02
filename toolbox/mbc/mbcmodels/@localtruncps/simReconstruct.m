function blk= simReconstruct(m,sname)
% LOCALBSPLINE/SIMRECONSTRUCT - nonlinear reconstruct block.
%
% BLK = simReconstruct(m,sname)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.5 $  $Date: 2004/04/04 03:29:47 $


% first add the relevant reconstruct block
blk = slRecon(m,sname);

% Calculate the parameter values.
Xvalues = code(m, get(m, 'values'));
featIndex = get(m, 'feat.index');
numKnots = length(m.knots);
knots = find(featIndex <= numKnots);
params = find(featIndex > numKnots);
polyOrder = m.order;
target = gettarget(m);

dG = delG(m);
dG = dG(params, numKnots+1:end);

funIndex = find(featIndex > size(m, 1)) - numKnots;

derivativeOrder = featIndex(params) - size(m, 1);
derivativeOrder(featIndex(params) == (size(m, 1) + m.order)) = 0;

vars = {'knots', 'params', 'funIndex', 'Xvalues', 'polyOrder', 'target', 'delG', 'derivativeOrder'};
values = cell(7, 1);
values{1} = knots;
values{2} = params;
values{3} = funIndex;
values{4} = Xvalues(params);
values{5} = polyOrder;
values{6} = target;
values{7} = dG;
values{8} = derivativeOrder;

AddVariablesToUserdata(blk, vars, values);
