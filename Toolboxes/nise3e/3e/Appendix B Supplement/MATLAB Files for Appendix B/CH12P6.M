% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch12p6) Example 12.8: We can design observer gains using the command 
% l = acker(A',C',poles)' without transforming to observer canonical form. Let us 
% look at Example 12.8 in the text.

'(ch12p6) Example 12.8'             % Display label.
A=[-5 1 0;0 -2 1;0 0 -1];           % Define system matrix A.
B=[0;0;1];                          % Define input matrix B.
C=[1 0 0];                          % Define output matrix C.
D=0;                                % Define matrix D.
poles=roots([1 120 2500 50000])     % Specify pole placement for all 
                                    % poles.
l=acker(A',C',poles)'               % Calculate observer gains.
