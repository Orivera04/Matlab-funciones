% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch12p5) Example 12.6: We can test observability using the MATLAB command 
% Om = obsv(A,C) to find the observability matrix given the system matrix (A) 
% and the output matrix (C). This command is followed by rank(Om) to test the
% rank of the observability matrix (Om). Let us apply the commands to
% Example 12.6.

'(ch12p5) Example 12.6'             % Display label.
A=[0 1 0;0 0 1;-4 -3 -2]            % Define compensated A matrix.
C=[0 5 1]                           % Define compensated C matrix.
Om=obsv(A,C)                        % Form observability matrix.
Rank=rank(Om)                       % Find rank of observability matrix.
