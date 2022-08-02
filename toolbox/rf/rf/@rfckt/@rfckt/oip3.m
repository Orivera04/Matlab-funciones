function result = oip3(h, freq)
%OIP3 Calculate the OIP3.
%   RESULT = OIPO3(H, FREQ) calculates the OIP3 of the RFCKT object at the
%   specified frequencies FREQ. The first input is the handle to the
%   RFCKT object, the second input is a vector for the specified freqencies.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2004/04/12 23:37:37 $

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
    result(1:length(f), 1) = inf;
end
