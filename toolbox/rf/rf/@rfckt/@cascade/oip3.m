function result = oip3(h, freq)
%OIP3 Calculate the OIP3.
%   RESULT = OIPO3(H, FREQ) calculates the OIP3 of the RFCKT object at the
%   specified frequencies FREQ. The first input is the handle to the RFCKT
%   object, the second input is a vector for the specified freqencies.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2004/04/12 23:36:18 $

error(nargchk(2,2,nargin))
% Get the data
data = get(h, 'RFdata');
if ~isa(data, 'rfdata.data') || (length(data.Freq) ~= length(freq)) ...
        || any(data.Freq(:) - freq(:))
    analyze(h, freq); 
    result = h.RFdata.OIP3;
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

% Calc the oip3
if budget
    for i=1:nckts
        temp = cascadedoip3(i, ckts);
        updatebudgetdata(budgetdata, temp, (i-1)*length(f));
    end
else
    temp = cascadedoip3(nckts, ckts);
end
result = temp2oip3(temp);


function updatebudgetdata(data, temp, k)
m = length(temp);
total_oip3 = get(data, 'OIP3');
oip3 = temp2oip3(temp);
total_oip3((k+1):(k+m), 1) = oip3(1:m, 1);
% Update the properties
set(data, 'OIP3', total_oip3);


function oip3 = temp2oip3(temp)
m = length(temp);
for i = 1:m
    if (temp(i, 1) == 0);
        oip3(i, 1) = inf;
    else
        oip3(i, 1) = 1./temp(i, 1);
    end
end


function temp = cascadedoip3(nckts, ckts)
ckt = ckts{nckts};
data = get(ckt, 'RFdata');
pgain = ckt.AvailablePowerGain;
temp = 1 ./ oip3(ckt, data.Freq);
for i=(nckts-1):-1:1
    ckt = ckts{i};
    data = get(ckt, 'RFdata');
    temp = temp + 1 ./ oip3(ckt, data.Freq) ./ pgain;
    % RF Circuit Design, p529
    pgain = pgain .* ckt.AvailablePowerGain;
end
