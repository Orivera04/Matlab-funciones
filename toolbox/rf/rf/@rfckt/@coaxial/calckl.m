function y = calckl(h, freq)
%CALCKL(H, FREQ) returns e^(-kl)
%   where k is the complex propogation constant 
%   and l is the transmission line length.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:36:20 $

c0 = 299792458; % speed of light in vacuum
mu0 = pi*4e-7;
mu = get(h, 'MuR')*mu0; % mu = Mu0 * MuR
e0 = 1/mu0/c0^2;
e = get(h, 'EpsilonR')*e0; % e = Epsilon0 * EpsilonR
sigmacond = get(h, 'SigmaCond');
sigmadiel = get(h, 'SigmaDiel');
a = get(h, 'InnerRadius');
b = get(h, 'OuterRadius');
len = get(h, 'LineLength');     % transmission line length
% Calculate Skin Depth delta
% delta is frequency dependent, hence delta is a vector
delta = 1./sqrt(pi*sigmacond*mu*freq);

% Calculate line parameters L, C, R and G
L = mu*log(b/a)/pi/2;
C = 2*pi*e/log(b/a);
G = 2*pi*sigmadiel/log(b/a);
if ~isinf(sigmacond)
    R = 1./(2*pi*sigmacond*delta)*(1/a+1/b);
else
    R = 0;
end

% Convert f to w
w = 2*pi*freq;
z0 = sqrt((R+j*w*L)./(G+j*w*C));  % characteristic impedance
k = sqrt((R+j*w*L).*(G+j*w*C)); % complex propogation constant

% Set characteristic impedance, phase velocity and Loss
set(h, 'Z0', z0)
pv = w./imag(k);
set(h, 'PV', pv)
alphadB = 20*log10(exp(real(k)));
set(h, 'Loss', alphadB)

y = exp(-k*len);
