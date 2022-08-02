% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% Chapter 13: Digital Control Systems
%
% ch13sp1 (Example 13.1)     MATLAB's Symbolic Math Toolbox 
% and the command, ztrans(f), can be used to find the 
% z-transform of a time function, f, represented as f(nT).
% MATLAB assumes that the default sampled-time independent variable 
% is n and the default transform independent variable is z. If you
% want to use k instead of n, i.e. f(kT), use ztrans(f,k,z).
% This command overrides MATLAB's defaults and assumes the 
% sampled-time independent variable to be k. Let us solve Example 13.1 
% using MATLAB's Symbolic Math Toolbox.

'(ch13sp1) Example 13.1'     % Display label.
syms n T                     % Construct symbolic objects for 
                             % 'n' and 'T'.
'f(nT)'                      % Display label.					 
f=n*T;                       % Define f(nT).
pretty(f)                    % Pretty print f(nT).
'F(z)'                       % Display label.
F=ztrans(f);                 % Find z-transform, F(z).
pretty(F)                    % Pretty print F(z).
