% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch6p2) Example 6.9: We can use MATLAB to find the range of gain for stability 
% by generating a loop, changing gain, and finding at what gain we obtain 
% right-half-plane poles.

'(ch6p2) Example 6.9'               % Display label.
K=[1:1:2000];                       % Define range of K from 1 to 2000 in 
                                    % steps of 1.
for n=1:length(K);                  % Set up length of DO LOOP to equal 
                                    % number of K values to be tested.
       dent=[1 18 77 K(n)];         % Define the denominator of T(s) for 
                                    % the nth value of K.
       poles=roots(dent);           % Find the poles for the nth value of 
                                    % K.
       r=real(poles);               % Form a vector containing the real 
                                    % parts of the poles for K(n).
             if max(r)>=0,          % Test poles found for the nth value 
                                    % of K for a real value ³ 0.
                  poles             % Display first pole values where
                                    % there is a real part > 0.
                  K=K(n)            % Display corresponding value of K.
                  break             % Stop loop if rhp poles are found.
       end                          % End if. 
end                                 % End for.
