function result = oip3(h, freq)
%OIP3 Calculate the OIP3.
%   RESULT = OIPO3(H, FREQ) calculates the OIP3 of the data object at the
%   specified frequencies FREQ. The first input is the handle to the data
%   object, the second input is a vector for the specified freqencies.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2004/04/12 23:38:22 $

% Set the default 
result = [];

error(nargchk(2,2,nargin))
% Get the parameters
f = get(h, 'Freq');
sparams = get(h, 'S_Parameters');
if isempty(sparams) || (length(f) ~= length(freq)) || (any(f(:) - freq(:)))
    analyze(h, freq); 
    result = h.OIP3;
    return;
end

refobj = get(h, 'Reference');
if isa(refobj, 'rfdata.reference')
    powerdata = get(refobj, 'PowerData');
    original_psat = [];
    if isa(powerdata, 'rfdata.power')
        original_freq = get(powerdata, 'Freq');
        original_pouts = get(powerdata, 'Pout');
        for j=1:length(original_freq)
            original_pout = original_pouts{j};
            original_psat(j) = original_pout(end);
        end
        if ~isempty(original_psat)
            original_oip3 = psat2oip3(original_psat);
            % Get the needed OIP3 using interpolation 
            result = interpolate(h, original_freq, original_oip3, f);
        end
    end
end
if isempty(result);  result = inf * ones(length(f), 1);  end;


function oip3 = psat2oip3(psat)
oip3 = psat * 27.0/4.0;
oip3(:);