function [type, netparameters, z0] = nwa(h, freq)
%NWA Calculate the network parameters.
%   [TYPE, NETWORKPARAMS, Z0] = NWA(H, FREQ) calculates the network
%   parameters of this circuit at the specified frequencies FREQ. The first
%   input is the handle to the circuit object, the second input is a vector
%   for the specified freqencies.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/12 23:36:30 $

% Get the RFDATA.DATA object 
data = get(h, 'RFdata');
set(data, 'IntpType', get(h, 'IntpType'));

% Calculate network parametters
[type, netparameters, z0] = nwa(data, freq);