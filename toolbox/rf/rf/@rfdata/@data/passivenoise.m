function nf = passivenoise(h, freq)
%PASSIVENOISE Calculate the passive noise figure.
%   NF = PASSIVENOISE(H, FREQ) calculates the noise figure of the passive
%   data object at the specified frequencies FREQ. The first input is the
%   handle to the data object, the second input is a vector for the
%   specified freqencies.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/20 23:19:47 $

% Get the data
sparams = get(h, 'S_Parameters');
z0 = 50;
sparams = s2s(sparams, h.Z0, z0);
[n1,n2,m] = size(sparams);
cs = zeros(n1,n2,m);
cs(1,1,:) = 1;
cs(2,2,:) = 1;
K = 1.380650e-23; 
for i = 1:m
    cs(:,:,i) = cs(:,:,i) + sparams(:,:,i) * conj(sparams(:,:,i)).';
end
%   cs = 290 * K * cs;
% The Wave Approach, (4.71) p69

gammas = (h.Zs - z0) ./ (h.Zs + z0);
nf = 1 + (cs(1,1,:) .* (abs(sparams(2,1,:) .* gammas ./ (1 - sparams(1,1,:) .* gammas)) .^ 2) ...
    + cs(2,2,:) + 2 * real(cs(1,2,:) .* sparams(2,1,:) * gammas ./ (1 - sparams(1,1,:) .* gammas))) ...
    ./ ((1 - abs(gammas) .^ 2) .* (abs(sparams(2,1,:) ./ (1 - sparams(1,1,:) .* gammas)) .^ 2));
% The Wave Approach, (4.105) p77
nf = abs(nf(:));

