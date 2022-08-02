function simSetEvalParam(m,sys)
%XREGARX\SIMSETEVALPARAM

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.2 $  $Date: 2004/02/09 07:45:37 $

vars = {'numInputSignals' 'selectedSignals' 'maxDelay' 'sampleTime' 'invcodeData' 'initialYValues'};
values = cell(6, 1);
values{1} = nfactors(m);
values{2} = i_getSelectedSignals(m);
values{3} = i_getMaxDelay(m);
values{4} = 1/m.Frequency;
values{5} = i_getInvCode(m);

% Get and code the initial Y values
y0 = get(m.StaticModel, 'initialconditions');
y0 = code(m.StaticModel,y0,nfactors(m.StaticModel));
values{6} = y0;

AddVariablesToUserdata(sys,vars,values);

% Ensure that the correct stuff for Static Model is created
simSetEvalParam(m.StaticModel, sys);

function index = i_getSelectedSignals(m)

start = get(m, 'delay') + 1;
stop  = sum(get(m, 'delmat'), 1);
maxDelay = max(stop);
nSignals = length(start);

index = zeros( maxDelay, nSignals );

for i = 1:nSignals
    index(start(i):stop(i),i) = 1;
end

index = find(index)';

function maxDelay = i_getMaxDelay(m)

delmat = get(m, 'delmat');
maxDelay = max(sum(delmat, 1));

function invcode = i_getInvCode(m)

c = get(m.StaticModel, 'code');
c = c(end);
invcode(1) = c.mid;
invcode(2) = (c.max - c.min)/c.range;
