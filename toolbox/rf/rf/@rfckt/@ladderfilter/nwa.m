function [type, netparameters, z0] = nwa(h, freq)
%NWA Calculate the network parameters.
%   [TYPE, NETWORKPARAMS, Z0] = NWA(H, FREQ) calculates the network
%   parameters of this circuit at the specified frequencies FREQ. The first
%   input is the handle to the circuit object, the second input is a vector
%   for the specified freqencies.

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/08 20:55:49 $

% Get and check the cascaded CKTS
ckts = get(h, 'CKTS');
nckts = length(ckts);

% Get the data
if ~isa(h.RFdata, 'rfdata.data')
    setrfdata(h, rfdata.data);
end
data = get(h, 'RFdata');

% Calculate the network parameters
if (nckts == 1)
    ckt = ckts{1};
    [type, netparameters, z0] = nwa(ckt, freq);
else 
    z0 = get(data, 'Z0');
    % Calculate the ABCD-parameters
    type = 'ABCD_PARAMETERS';
    ckt = ckts{1};
    [ckt_type, ckt_params, ckt_z0] = nwa(ckt, freq);
    netparameters = convertmatrix(data, ckt_params, ckt_type, type, ckt_z0);
    [n1,n2,m] = size(netparameters);
    for i=2:nckts
        ckt = ckts{i};
        [ckt_type, ckt_params, ckt_z0] = nwa(ckt, freq);
        ckt_params = convertmatrix(data, ckt_params, ckt_type, type, ckt_z0);
        for k=1:m
            netparameters(:,:,k) = netparameters(:,:,k)*ckt_params(:,:,k);
        end
    end
end