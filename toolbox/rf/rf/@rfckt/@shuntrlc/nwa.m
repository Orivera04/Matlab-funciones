function [type, netparameters, z0] = nwa(h, freq)
%NWA Calculate the network parameters.
%   [TYPE, NETWORKPARAMS, Z0] = NWA(H, FREQ) calculates the network
%   parameters of this circuit at the specified frequencies FREQ. The first
%   input is the handle to the circuit object, the second input is a vector
%   for the specified freqencies.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/12 23:37:53 $

% Allocate memory for netparameters
nport = get(h, 'nPort');
netparameters  = zeros(nport,nport,length(freq));

% Get the properties of the Shunt RLC object
r = get(h, 'R');
l = get(h, 'L');
c = get(h, 'C');

% Get angular frequency
w = 2*pi*freq;

% Get number of frequency elements
numElem = numel(freq);

% Default behavior is a pass-through, i.e., shunt admittance Y=0
ynum = 0;
yden = 1;
% Calculate Y for all possible scenarios of R, L and C
if (~isinf(r) | ~isinf(l) | c~=0)
    if ~isinf(r)
        ynum = 1/r;
    end
    if c~=0
        ynum = [c ynum];
    end
    if ~isinf(l)
        ynum = [l*ynum 1];
        yden = [l 0];
    end
end

% Compute ABCD parameters
A = ones(numElem,1);
B = zeros(numElem,1);
C = polyval(ynum,(j*w))./polyval(yden,(j*w));
D = ones(numElem,1);    

% Assign ABCD-parameters 
type = 'ABCD_PARAMETERS';
netparameters(1,1,:)= A; 
netparameters(1,2,:)= B;
netparameters(2,1,:)= C; 
netparameters(2,2,:)= D; 

% Specify the characteristic impedance 
z0 = 50;