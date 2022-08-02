% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%																												
% (ch2p5): We can find roots of polynomials using the roots(V) command. 
% The roots are returned as a column vector. For example, find the 
% roots of 5s^4+7s^3+9s^2-3s+2 = 0.

'(ch2p5)'                           % Display label.
P4=[5 7 9 -3 2]                     % Form 5s^4+7s^3+9s^2-3s+2 and 
                                    % display.	
rootsP4=roots(P4)                   % Find roots of 5s^4+7s^3+9s^2-3s+2, 
                                    % assign to rootsP4, and display.     
