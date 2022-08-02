% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch13p7) Example 13.10:    We now use the root locus to find the gain for 
% stability. First, we create a digital LTI transfer-function object for 
% G(z) = N(z)/D(z), with an unspecified sampling interval. The LTI object is created 
% using tf(numgz,dengz,[]), where numgz represents N(z), dengz represents D(z), 
% and [] indicates an unspecified sampling interval. MATLAB produces a z-plane root 
% locus along with the unit circle superimposed using the command, zgrid(z,wn), 
% with z = wn = 0. We then interactively select the intersection of the root locus 
% and the unit circle. MATLAB responds with the value of gain and the closed-loop 
% poles. Let us look at Example 13.10.

'(ch13p7) Example 13.10'            % Display label.
clf                                 % Clear graph.
numgz=[1 1];                        % Define numerator of G(z).
dengz=poly([1 0.5]);                % Define denominator of G(z).
'G(z)'                              % Display label.
Gz=tf(numgz,dengz,[])               % Create and display G(z).
rlocus(Gz)                          % Plot root locus.
zgrid(0,0)                          % Add unit circle to root locus.
title(['z-Plane Root Locus'])       % Add title to root locus.
[K,p]=rlocfind(Gz)                  % Allows input of K by selecting 
                                    % point on graphic.
