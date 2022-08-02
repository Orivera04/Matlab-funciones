% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch10p3) Example 10.8: We can use MATLAB to find gain margin(Gm), phase 
% margin(Pm), the gain-margin frequency, where the phase plot goes through 
% 180 degrees(Wcg), and the phase-margin frequency, where the magnitude 
% plot goes through 0 dB(Wcp) To find these quantities we use 
% [Gm,Pm,Wcg,Wcp] = margin(G), where G(s) = numg/deng and G is an LTI 
% transfer-function object. Let us look at Example 10.8 in the text.

'(ch10p3) Example 10.8'             % Display label.
clf                                 % Clear graph on screen.
numg=6;                             % Define numerator of G(s).
deng=conv([1 2],[1 2 2]);           % Define denominator of G(s).
'G(s)'                              % Display label.
G=tf(numg,deng)                     % Create and display G(s).
grid on                             % Turn on grid for the Nyquist plot.
nyquist(G)                          % Make a Nyquist diagram.
title('Open-Loop Frequency Response') 		
                                    % Add a title to the Nyquist diagram.
[Gm,Pm,Wcg,Wcp]=margin(G);          % Find margins and margin 
                                    % frequencies.
'Gain margin(dB); Phase margin(deg.); 180 deg. freq.(r/s);' 
'0 dB freq.(r/s)'                   % Display label.
margins=[20*log10(Gm),Pm,Wcg,Wcp]   % Display margin data.
