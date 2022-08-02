function nf = noise(h, freq)
%NOISE Calculate the noise figure.
%   NF = NOISE(H, FREQ) calculates the noise figure of the RFCKT object at
%   the specified frequencies FREQ. The first input is the handle to the
%   RFCKT object, the second input is a vector for the specified
%   freqencies.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2004/04/12 23:36:16 $

error(nargchk(2,2,nargin))
% Get the data
data = get(h, 'RFdata');
if ~isa(data, 'rfdata.data') || (length(data.Freq) ~= length(freq)) ...
        || any(data.Freq(:) - freq(:))
    analyze(h, freq); 
    nf = h.RFdata.NF;
    return;
end

f = data.Freq;
ckts = get(h, 'CKTS');
nckts = length(ckts);
budget = false;
cflag = get(h, 'Flag');
setflagindexes(h);
% To see if the analysis is needed
if (bitget(cflag, indexOfTheBudgetAnalysisOn) == 1)
    budget = true;
    % Get the budget data
    budgetdata = get(data, 'BudgetData');
end

% Calc the noise figure
if (nckts == 1)
    ckt = ckts{1};
    nf = noise(ckt, f);
    if budget
        updatebudgetdata(budgetdata, nf, 0);
    end
else 
    ckt = ckts{1};
    data = get(ckt, 'RFdata');
    set(ckt, 'AvailablePowerGain', ga(data));
    pgain = ckt.AvailablePowerGain;
    nf = noise(ckt, data.Freq);
    if budget
        updatebudgetdata(budgetdata, nf, 0);
    end
    for i=2:nckts
        ckt = ckts{i};
        data = get(ckt, 'RFdata');
        nf = nf + (noise(ckt, data.Freq) - 1) ./ pgain;
        % Analysis and Design, (4.3.1) p299
        set(ckt, 'AvailablePowerGain', ga(data));
        pgain = pgain .* ckt.AvailablePowerGain;
        if budget
            updatebudgetdata(budgetdata, nf, (i-1)*length(f));
        end
    end
end


function updatebudgetdata(data, nf, k)
m = length(nf);
total_nf = get(data, 'NF');
total_nf((k+1):(k+m), 1) = nf(1:m, 1);
% Update the properties
set(data, 'NF', total_nf);
