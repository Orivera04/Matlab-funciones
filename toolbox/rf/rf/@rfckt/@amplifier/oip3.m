function result = oip3(h, freq)
%OIP3 Calculate the OIP3.
%   RESULT = OIPO3(H, FREQ) calculates the OIP3 of the circuit object at
%   the specified frequencies FREQ. The first input is the handle to the
%   circuit object, the second input is a vector for the specified
%   freqencies.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/12 23:36:11 $

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
% Calc the noise figure
result = oip3(data, f);
if isempty(result) 
    if ~(h.OIP3 == inf)
        temp = h.OIP3;
    elseif ~(h.IIP3 == inf)
        iip3 = get(h, 'IIP3');
        if isa(data, 'rfdata.data')
            smatrix = get(data, 'S_Parameters');
            if ~isempty(smatrix)
                gain = sqrt(ga(data));
            end
        end
        temp = iip3 + 20.*log10(gain);
    else
        temp = inf;
    end
    result(1:length(f), 1) = 0.001.*10.^(temp/10);
end
