function b = beam_ta(psiv,x,psi0,lambda)

%BEAM_TA Calculate the beam pattern for a line array.
%       B = BEAM_TA(PSIV,X,PSI0,LAMBDA) Returns the beam pattern B =
%       (|G|/|G_max|)^2 at angles defined by the vector PSIV for a line of
%       hydrophones at locations X. PSI0 is the steering angle and lambda is
%       the wavelength.

% (See Workbook 3, p 40)
% A. Knight, July 1995

[PSI,X] = meshgrid(psiv,x);
i = sqrt(-1);
G = sum(exp(i*2*pi*X.*(sin(PSI) - sin(psi0))/lambda));
Gmax = max(G);
b = (abs(G)/Gmax).^2;
