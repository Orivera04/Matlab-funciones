function [type, netparameters, z0] = nwa(h, freq)
%NWA Calculate the network parameters.
%   [TYPE, NETWORKPARAMS, Z0] = NWA(H, FREQ) calculates the network
%   parameters of the data at the specified frequencies FREQ. The first
%   input is the handle to the data object, the second input is a vector
%   for the specified freqencies.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/12 23:38:21 $

% Get the original frequency and S_Parameters
original_freq = get(h, 'Freq');        
original_sparams = get(h, 'S_Parameters');
method = get(h, 'IntpType');
N = length(freq);

if isempty(original_freq) || isempty(original_sparams)
    type = 'S_PARAMETERS';
    [netparameters(1,1,1:N), netparameters(1,2,1:N), ...
        netparameters(2,1,1:N), sparams(2,2,1:N)] = deal(0, 1, 1, 0);
    z0 = 50;
    return;
end
    
% Check Freq and S-parameters 
[n1,n2,m] = size(original_sparams);
nport = n1;

% Check the data to determine if an interpolation is needed
M = length(original_freq);
if M == 1 
    % No need interpolation
    [sparams(1,1,1:N), sparams(1,2,1:N), sparams(2,1,1:N), sparams(2,2,1:N)] ...
        = deal(original_sparams(1,1,1), original_sparams(1,2,1), ...
        original_sparams(2,1,1), original_sparams(2,2,1));
elseif (length(freq) == length(original_freq)) && all(original_freq == freq)
    % No need interpolation
    sparams = original_sparams;
else
    % Sort the data 
    [original_freq, freqindex] = sort(original_freq);
    original_sparams(:,:,:) = original_sparams(:,:,freqindex);

    % Interpolate
    for k1=1:nport
        for k2=1:nport
            sdata = original_sparams(k1,k2,:);
            sdata = interp1(original_freq, sdata(:), freq, method, NaN);
            sparams(k1,k2,:) = sdata;
        end
    end
    
    % Extrapolate
    lowerindex = min(find(freq >= original_freq(1)));
    index = find(freq < original_freq(1));
    if ~isempty(index)
        if ~isempty(lowerindex)
            sparams(:,:,index) = repmat(sparams(:,:,lowerindex), ...
                [1 1 length(index)]);
        else
            sparams(:,:,index) = repmat(original_sparams(:,:,1), ...
                [1 1 length(index)]);
        end
    end
    
    upperindex = max(find(freq <= original_freq(end)));
    index = find(freq > original_freq(end));
    if ~isempty(index)
        if ~isempty(upperindex)
            sparams(:,:,index) = repmat(sparams(:,:,upperindex), ...
                [1 1 length(index)]);
        else
            sparams(:,:,index) = repmat(original_sparams(:,:,end), ...
                [1 1 length(index)]);
        end
    end    
end

type = 'S_PARAMETERS';
netparameters = sparams;
z0 = get(h, 'Z0');
