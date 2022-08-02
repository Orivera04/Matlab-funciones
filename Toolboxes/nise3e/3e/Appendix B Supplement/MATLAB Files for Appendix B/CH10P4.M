% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch10p4) Example 10.9: We can use MATLAB to determine the range of K for 
% stability using frequency response methods. Let us look at Example 10.9 in the 
% text.

'(ch10p4) Example 10.9'             % Display label.
numg=1;                             % Define numerator of G(s).
deng=poly([-2 -4 -5]);              % Define denominator of G(s).
'G(s)'                              % Display label.
G=tf(numg,deng)                     % Create and display G(s).
[Gm,Pm,Wcg,Wcp]=margin(G);          % Find margins and margin
                                    % frequencies.
K=Gm                                % Display K for stability.
