function blk= simReconstruct(m,sname)
% LOCALBSPLINE/SIMRECONSTRUCT - nonlinear reconstruct block.
%
% BLK = simReconstruct(m,sname)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:38:24 $


% first add the relevant reconstruct block
blk = slRecon(m,sname);

% Calculate the parameter values.
Xvalues = code(m, get(m, 'values'));
featIndex = get(m, 'feat.index');
knots = find(featIndex <= get(m, 'numknots'));
params = find(featIndex > get(m, 'numknots'));
polyOrder = get(m, 'polyorder');
target = gettarget(m);

vars = {'knots', 'params', 'paramIndex', 'Xvalues', 'polyOrder', 'target'};
values = {knots params featIndex(params) Xvalues(params) polyOrder target};

AddVariablesToUserdata(blk, vars, values);
