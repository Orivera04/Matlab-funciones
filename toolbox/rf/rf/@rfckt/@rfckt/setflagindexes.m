function setflagindexes(h)
%SETFLAGINDEXES Set the indexes for flag.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:37:40 $

evalStr1 = '';
flagNames = {'NonLinear', 'TheBudgetAnalysisOn', 'NoiseOn', 'NeedToUpdate', ...
    'ActiveNoise', 'NoiseLess', 'ThePropertyIsChecked',  'MaxNumberOfFlags'};
N = length(flagNames);
for n = 1:N-1
    flafName  = flagNames{n};
    evalStr1 = [evalStr1 sprintf('indexOf%s = %d;', flafName, n)];
end;
flagName  = flagNames{N};
evalStr1 = [evalStr1 sprintf('%s = %d;', flagName, N)];
evalin('caller',evalStr1);
return;