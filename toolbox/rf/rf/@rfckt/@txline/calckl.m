function y = calckl(h, freq)
%CALCKL(H, FREQ) return e^(-kl)
%   where k is the complex propogation constant 
%   and l is the transmission line length.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/12 23:38:00 $

error(nargchk(2,3,nargin));
len = get(h, 'LineLength');     % transmission line length
alphadB = get(h, 'Loss');
pv = get(h, 'PV'); 
% z0 = get(h, 'Z0');

% Check the Loss
if length(alphadB) == 1
    alphadB = alphadB*ones(size(freq));
elseif length(alphadB) ~= length(freq);
    id = sprintf('rf:%s:calckl:LossFreq',strrep(class(h),'.',':'));
    error(id, 'Length of Loss must equal length of freq or 1.');
end
alphadB = alphadB(:);

% Check the phase velocity
if length(pv) == 1
    pv = pv*ones(size(freq));
elseif length(pv) ~= length(freq);
    id = sprintf('rf:%s:calckl:PVFreq',strrep(class(h),'.',':'));
    error(id, 'Length of PV must equal length of freq or 1.');
end
pv = pv(:);

% Get wave number (propogation constant) beta
beta = 2*pi*freq./pv;
% Get the exponent of attenuation coefficient times -len
e_negalphal = (10.^(-alphadB./20)).^len; % e_negalphal stands for e^(-alpha*len)
% k = alpha + j*beta; % complex propogation constant

y = e_negalphal .* exp(-j*beta*len);
