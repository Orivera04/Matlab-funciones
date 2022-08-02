function y = calckl(h, freq)
%CALCKL(H, FREQ) returns e^(-kl)
%   where k is the complex propogation constant 
%   and l is the transmission line length.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:37:10 $

% Declare constants
c0 = 299792458; % speed of light in vacuum
mu0 = pi*4e-7; % permeability constant
e0 = 1/mu0/c0^2; % permittivity in vacuum
Er = get(h, 'EpsilonR'); % relative permittivity constant
zf = sqrt(mu0/e0); % wave impedance in free space
lamda0 = c0./freq; % wave length in vacuum

% Get parameters
len = get(h, 'LineLength');
width = get(h, 'Width');
height = get(h, 'Height');
thickness = get(h, 'Thickness');
sigmacond = get(h, 'SigmaCond');
losstan = get(h, 'LossTangent');

% Calculate we using equation (2.125) on page 105 of Microstrip Lines and
% Slotlines by K.C.Gupta.
we = calc_we(width, height, thickness);

% See C in equation (2.127)
TempC = (Er-1)*thickness/height/4.6/sqrt(width/height);
if width/height <= 1 % narrow strip line
    % Calculate effective dielectric constant
    TempA = (1+12*height/width)^(-1/2) + 0.04*(1-width/height)^2;
    % effective dielectric constant
    Eeff = (Er+1)/2 + (Er-1)/2*TempA - TempC;
    
    % Calculate characteristic impedance
    TempA = log(8*height/we + 0.25*we/height);
    z0 = zf/2/pi/sqrt(Eeff)*TempA; % characteristic impedance
else % wide strip line
    % Calculate effective dielectric constant
    Eeff = (Er+1)/2 + (Er-1)/2*(1+12*height/width)^(-1/2) - TempC;
    
    % Calculate characteristic impedance
    TempA = we/height + 1.393 + 2/3*log(we/height+1.444);
    z0 = zf/sqrt(Eeff)/TempA; % characteristic impedance
end

% Effect of Dispersion (frequency dependent)
% See equations (2.130) and (2.131) on page 107
TempA = Er*sqrt((Eeff-1)/(Er-Eeff));
fk_TM0 = c0*atan(TempA)/(2*pi*height*sqrt(Er-Eeff));

TempA = 0.75 + (0.75 - (0.332/Er^1.73))*width/height;
f50 = fk_TM0/TempA;

m0 = 1 + 1/(1+sqrt(width/height)) + 0.32*(1/(1+sqrt(width/height)))^3;
mc = calc_mc(width, height, f50, freq);
m = m0*mc;
% frequency dependent effective dielectric constant
Eeff_f = Er - (Er-Eeff)./(1+(freq./f50).^m);
% frequency dependent characteristic impedance
z0_f = z0*(Eeff_f-1)./(Eeff-1).*sqrt(Eeff./Eeff_f);
pv = c0./sqrt(Eeff_f); % frequency dependent phase velocity

% Get frequency in rad/s
w = 2*pi*freq;
% Calculate wave number beta
beta = w./pv;

% Calculate Loss, see equation (2.133) and (2.134) on page 108
Rs = sqrt(pi*freq*mu0./sigmacond); % sheet resistance
% Note: if sigmacond is inf, Rs is zero

TempB = calc_B(width, height);
% delta = 1./sqrt(pi*sigmacond*mu*freq); % skin depth
TempA = 1 + height/we*(1+1.25/pi*log(2*TempB/thickness));

if width/height <= 1 % narrow strip line
    TempC = (32-(we/height)^2)/(32+(we/height)^2);
    alpha_c = 1.38*TempC/height/z0*TempA.*Rs; % conductor loss (dB/m)
else
    TempC = we/height + 2/3*we/height/(we/height+1.444);
    % conductor loss (dB/m)
    alpha_c = 6.1e-5*TempA*z0*TempC.*Rs.*Eeff_f./height;
end
% dielectric loss (dB/m)
alpha_d = 27.3*Er/(Er-1)*(Eeff_f-1).*losstan./sqrt(Eeff_f)./lamda0;

alphadB = alpha_c + alpha_d; % total loss in dB/m
% e^(-alpha*L) where alpha is the attenuation coefficient
e_alpha = (10.^(-alphadB./20)).^len;

% set PV, Loss and Z0
set(h, 'PV', pv)
set(h, 'Loss', alphadB)
set(h, 'Z0', z0_f)

y = e_alpha .* exp(-j*beta*len);

%-----------------------------------------
function we = calc_we(w, h, t)
%CALC_WE calculate effective width of a microstripline

% % Check for zero thickness
% if t == 0
%     we = w;
%     return
% end

if w/h <= 1/2/pi
    we = w + 1.25*t/pi*(1+log(4*pi*w/t));
else
    we = w + 1.25*t/pi*(1+log(2*h/t));
end

%----------------------------------------
function mc = calc_mc(w, h, f50, f);

if w/h <= 0.7
    TempA = 0.15 - 0.235*exp(-0.45*f./f50);
    mc = 1 + 1.4/(1+w/h)*TempA;
else
    mc = 1;
end

%----------------------------------------
function B = calc_B(w, h);

if w/h <= 1/2/pi
    B = 2*pi*w;
else
    B = h;
end
