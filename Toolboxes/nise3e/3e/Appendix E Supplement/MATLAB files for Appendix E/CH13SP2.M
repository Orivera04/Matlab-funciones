% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% ch13sp2 (Example 13.2)     MATLAB's Symbolic Math Toolbox 
% and the command, iztrans(F), can be used to find the
% time-sampled function represented as f(nT) given its 
% z-transform, F(z). If you want the sampled time function 
% returned as f(kT), then change MATLAB's default independent 
% sampled-time variable by using the command, iztrans(F,k). 
% Let us solve Example 13.2 using MATLAB's Symbolic Math Toolbox.

'(ch13sp2) Example 13.2'     % Display label.
syms z k                     % Construct symbolic objects for 
                             % 'z' and 'k'.
'F(z)'                       % Display label.					 
F=0.5*z/((z-0.5)*(z-0.7));   % Define F(z).
pretty(F)                    % Pretty print F(z).
'f(kT)'                      % Display label.
f=iztrans(F,k);              % Find inverse z-transform, f(kT).
pretty(f)                    % Pretty print f(kT).
'f(nT)'                      % Display label.
f=iztrans(F);                % Find inverse z-transform, f(nT).
pretty(f)                    % Pretty print f(nT).
