% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%																													
% (ch2p7): The partial-fraction expansion for F(s) = b(s)/a(s) can be found 
% using the [K,p,k] = residue(b,a) command (K = residue; p = roots of denominator; 
% k = direct quotient, which is found by dividing polynomials prior 
% to performing a partial-fraction expansion). We expand 
% F(s) = (7s^2+9s+12)/[s(s+7)(s^2+10s+100)] as an example. Using 
% the results from MATLAB yields: F(s) = [(0.2554 - 0.3382i)/(s+5.0000 - 8.6603i)] +  
% [(0.2554 + 0.3382i)/(s+5.0000 + 8.6603i)] - [0.5280/(s+7)] +[ 0.0171/s].

'(ch2p7)'                           % Display label.
numf=[7 9 12];                      % Define numerator of F(s).
denf=conv(poly([0 -7]),[1 10 100]); % Define denominator of F(s).
[K,p,k]=residue(numf,denf)          % Find residues and assign to K; 
                                    % find roots of denominator and 
                                    % assign to p; find
                                    % constant and assign to k.
