function [type, netparameters, z0] = nwa(h, freq)
%NWA Calculate the network parameters.
%   [TYPE, NETWORKPARAMS, Z0] = NWA(H, FREQ) calculates the network
%   parameters of this circuit at the specified frequencies FREQ. The first
%   input is the handle to the circuit object, the second input is a vector
%   for the specified freqencies.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.11 $  $Date: 2004/04/12 23:36:17 $

% Get and check the cascaded CKTS
ckts = get(h, 'CKTS');
nckts = length(ckts);

% Get the data
if ~isa(h.RFdata, 'rfdata.data')
    setrfdata(h, rfdata.data);
end
data = get(h, 'RFdata');

budget = false;
cflag = get(h, 'Flag');
setflagindexes(h);
% To see if the analysis is needed
if (bitget(cflag, indexOfTheBudgetAnalysisOn) == 1)
    budget = true;
    % Get the budget data
    if ~isa(data.BudgetData, 'rfdata.data')
        set(data, 'BudgetData', rfdata.data);
    end
    budgetdata = get(data, 'BudgetData');
    n = nckts * length(freq);
    sparams = zeros(2,2,n);
    nf = ones(n, 1);
    oip3(1:n, 1) = inf;
    set(budgetdata, 'S_Parameters', sparams, 'Freq', freq, 'NF', nf, 'OIP3', oip3);
end

% Calculate the network parameters
if (nckts == 1)
    ckt = ckts{1};
    [type, netparameters, z0] = nwa(ckt, freq);
    updatecktdata(ckt, netparameters, type, freq, z0);
    if budget
        updatebudgetdata(budgetdata, netparameters, type, freq, z0, 0);
    end
else 
    z0 = get(data, 'Z0');
    % Calculate the ABCD-parameters
    type = 'ABCD_PARAMETERS';
    ckt = ckts{1};
    [ckt_type, ckt_params, ckt_z0] = nwa(ckt, freq);
    netparameters = convertmatrix(data, ckt_params, ckt_type, type, ckt_z0);
    updatecktdata(ckt, netparameters, type, freq);
    if budget
        updatebudgetdata(budgetdata, netparameters, type, freq, ckt_z0, 0);
    end    
    [n1,n2,m] = size(netparameters);
    freq = convertfreq(ckt, freq);
    for i=2:nckts
        ckt = ckts{i};
        [ckt_type, ckt_params, ckt_z0] = nwa(ckt, freq);
        ckt_params = convertmatrix(data, ckt_params, ckt_type, type, ckt_z0);
        updatecktdata(ckt, ckt_params, type, freq);
        for k=1:m
            netparameters(:,:,k) = netparameters(:,:,k)*ckt_params(:,:,k);
        end
        if budget
            updatebudgetdata(budgetdata, netparameters, type, freq, ckt_z0, ...
                (i-1)*length(freq));
        end
        freq = convertfreq(ckt, freq);
    end
end


function updatecktdata(ckt, netparameters, type, freq, ckt_z0)
% Create an RFDATA.DATA object if needed
if ~isa(ckt.RFdata, 'rfdata.data')
    setrfdata(ckt, rfdata.data);
end
data = get(ckt, 'RFdata');
% Calculate the S-parameters
z0 = get(data, 'Z0');
if strncmpi(type,'S',1)
    sparams = s2s(netparameters, ckt_z0, z0);
else
    sparams = convertmatrix(data, netparameters, type, 'S_PARAMETERS', z0);
end
% Update the properties of RFDATA.DATA object
set(data, 'S_Parameters', sparams, 'Freq', freq);


function updatebudgetdata(data, netparameters, type, freq, ckt_z0, k)
% Calculate the S-parameters
z0 = get(data, 'Z0');
if strncmpi(type,'S',1)
    sparams = s2s(netparameters, ckt_z0, z0);
else
    sparams = convertmatrix(data, netparameters, type, 'S_PARAMETERS', z0);
end

[n1,n2,m] = size(netparameters);
total_sparames = get(data, 'S_Parameters');
total_sparames(:,:,(k+1):(k+m)) = sparams(:,:,1:m);
% Update the properties
set(data, 'S_Parameters', total_sparames, 'Freq', freq);
