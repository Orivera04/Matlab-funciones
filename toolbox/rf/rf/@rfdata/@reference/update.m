function h = update(h,networktype,freq,netparams,z0,noisefreq,fmin,gammaopt,rn,pfreq,pin,power,phase)
%UPDATE Update the properties with the inputs.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2004/04/12 23:38:43 $

% Get the properties
netdata = get(h, 'NetworkData');
noisedata = get(h, 'NoiseData');
powerdata = get(h, 'PowerData');

% Update the properties
if ~isempty(freq) && ~isempty(netparams)
    if isa(netdata, 'rfdata.network')
        set(netdata, 'Type', networktype, 'Freq', freq, 'Data', netparams, ...
        'Z0', z0);
    else
        netdata = rfdata.network('Type', networktype, 'Freq', freq, 'Data', ...
            netparams, 'Z0', z0);
        set(h, 'NetworkData', netdata);
    end
else
    set(h, 'NetworkData', []);
end

if ~isempty(noisefreq) && ~isempty(fmin) && ~isempty(gammaopt) && ...
        ~isempty(rn)
    % [fmin, gammaopt, rn] = getnoisedata(noiseparams);
    if isa(noisedata, 'rfdata.noise')
        set(noisedata, 'Freq', noisefreq, 'FMIN', fmin, 'GAMMAOPT', ...
            gammaopt, 'RN', rn);
    else
        noisedata = rfdata.noise('Freq', noisefreq, 'FMIN', fmin, ...
            'GAMMAOPT', gammaopt, 'RN', rn);
        set(h, 'NoiseData', noisedata);
    end
else
    set(h, 'NoiseData', []);
end

if ~isempty(pin) && ~isempty(power)
    if isa(powerdata, 'rfdata.power')
        set(powerdata, 'Freq', pfreq, 'Pin', pin, 'Pout', power, ...
            'Phase', phase);
    else
        powerdata = rfdata.power('Freq', pfreq, 'Pin', pin, 'Pout', power, ...
            'Phase', phase);
        set(h, 'PowerData', powerdata);
    end
else
    set(h, 'PowerData', []);
end

% function [fmin, gammaopt, rn] = getnoisedata(noiseparams);
% fmin = noiseparams(:, 1);
% fmin = 10.^(fmin/10);
% R = noiseparams(:, 2);
% theta = noiseparams(:, 3) * pi/180;
% gammaopt = R.*exp(i*theta);
% rn = noiseparams(:, 4);