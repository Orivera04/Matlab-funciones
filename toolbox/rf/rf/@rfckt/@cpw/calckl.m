function y = calckl(h, freq)
%CALCKL(H, FREQ) return e^(-kl)
%   where k is the complex propagation constant 
%   and l is the transmission line length.
%
%   References:
%   Gupta, K.C. Microstrip Lines and Slotlines. Boston, Artech House, 1996.  

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $ $Date: 2004/04/12 23:36:24 $

% Declare constants
c0 = 299792458; % velocity of light in vacuum
mu0 = pi*4e-7; % free space permeability 
lambda0 = c0./freq; % wavelength in vacuum

% Get parameters
len = get(h, 'LineLength');
width = get(h, 'ConductorWidth');
slotwidth = get(h, 'SlotWidth');
height = get(h, 'Height');
thickness = get(h, 'Thickness');
Er = get(h, 'EpsilonR');
sigmacond = get(h, 'SigmaCond');
losstan = get(h, 'LossTangent');

% Begin processing the characteristic impedance ---------------------------

% Define useful quantities based on CPW geometry - refer to figure 7.1a,
% 7.3a, and 7.6b
a = width/2;
b = width/2 + slotwidth;

k1 = a/b; % See equation (7.7)

t1 = sinh(pi*a/(2*height)); % See equation (7.14a)
t2 = sinh(pi*b/(2*height)); % See equation (7.14b)

k2 = t1/t2; % See equation (7.16)

% Calculate the complete elliptic integrals of the first kind and its
% complement
K_k1 = ellipke(k1);
K_k2 = ellipke(k2);

Kp_k1 = calcKp(k1);
Kp_k2 = calcKp(k2);

% Filling factor from equation (7.19a)
q = 0.5*K_k2/Kp_k2*Kp_k1/K_k1;

% Calculate the effective dielectric constant ignoring the conductor
% thickness - see equation (7.18) 
Ere_t = 1 + q*(Er-1);

% Effect of metallization thickness on the effective dielectric constant -
% see equation (7.100)
Ere = Ere_t - (0.7*(Ere_t-1)*(thickness/slotwidth))/(K_k1/Kp_k1+0.7 ...
    *(thickness/slotwidth));

% Define useful quantities for the evaluation of the frequency dependent
% effective dielectric constant
p = log(2*a/height);

u = 0.54 - 0.64*p + 0.015*p^2;
v = 0.43 - 0.86*p + 0.54*p^2;

G = exp(u*log(2*a/(b-a))+v);

% Cutoff frequency for the TE0 surface wave mode of the substrate - see
% equation (7.95)
fTE = c0/(4*height*sqrt(Er-1));

% Effect of dispersion on the effective dielectric constant - see equation
% (7.94). Expected accuracy is 5 percent for: 0.1 < slotwidth/height < 5, 
% 1.5 < Er < 50, 0.1 < width/slotwidth < 5, 0 < f/fTE < 10. 
Ere_f = (sqrt(Ere) + (sqrt(Er)-sqrt(Ere))./(1+G*(freq/fTE).^-1.8)).^2;

% Define useful quantities for the evaluation of the effect of
% metallization thickness on the characteristic impedance
delta = 1.25*thickness/pi*(1+log(4*pi*width/thickness)); % See equation (7.98)

we = width + delta; % See equation (7.97a)
se = slotwidth - delta; % See equation (7.97b)

ke = we/(we+2*se);

K_ke = ellipke(ke);
Kp_ke = calcKp(ke);

% Effect of dispersion and metallization thickness on the characteristic
% impedance - see equations (7.96), (7.99)
Z0_f = 30*pi*Kp_ke/K_ke./sqrt(Ere_f);

% End of characteristic impedance processing ------------------------------

w = 2*pi*freq; % convert frequency to rad/s

% Calculate the phase velocity and the phase constant
pv = c0./sqrt(Ere_f);
beta = w./pv;

% Begin processing the CPW losses -----------------------------------------

% Sheet resistance. Note: if sigmacond is inf, Rs is zero.
Rs = sqrt(pi*freq*mu0./sigmacond); 

% Dielectric loss (dB/m) - from equation (2.81)
alpha_d = 27.3*Er/(Er-1)*(Ere_f-1).*losstan./sqrt(Ere_f)./lambda0;

% Conductor loss (dB/m) - from equation (7.109). Expression assumes 
% t > 3*delta and t << a, (b-a).
tempA = (pi+log((8*pi*a*(1-k1))/(thickness*(1+k1))))/a;
tempB = (pi+log((8*pi*b*(1-k1))/(thickness*(1+k1))))/b;
alpha_c = 8.68*Rs.*sqrt(Ere_f)./(480*pi*K_k1*Kp_k1*(1-k1^2))* ... 
    (tempA + tempB);

alphadB = alpha_d + alpha_c; % total loss in dB/m
alpha = log(10.^(alphadB/20)); % total loss in neper/m

% End of CPW loss processing ----------------------------------------------

k = alpha + j*beta; % propagation constant
y = exp(-len*k);

% Set the CPW properties
set(h, 'PV', pv, 'Loss', alphadB, 'Z0', Z0_f)

% EOF -- calckl.m

%--------------------------------------------------------------------------
function Kp = calcKp(k)
%CALCKP Calculate the complement of the complete elliptic integral of the
% first kind.

kp = sqrt(1-k^2);  % See equation (7.6)
Kp = ellipke(kp);

% EOF -- calcKp.m
