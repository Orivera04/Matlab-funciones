% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch5p5): Using MATLAB's [P,d] = eig(A) command, where the columns of P are the 
% eigenvectors of A and the diagonal elements of d are the eigenvalues of A,  
% we can find the eigenvectors of the system matrix and then proceed to diagonalize 
% the system. We can also use canon(S,'modal') to diagonalize an LTI object, S, 
% represented in state space. 

'(ch5p5)'                           % Display label.
A=[3 1 5;4 -2 7;2 3 1];             % Define original A.
B=[1;2;3];                          % Define original B.
C=[2 4 6];                          % Define original C.
[P,d]=eig(A)                        % Generate transformation matrix, P, 
                                    % and eigenvalues, d.
'Via Transformation'                % Display label.
Adt=inv(P)*A*P                      % Calculate diagonal system A.
Bdt=inv(P)*B                        % Calculate diagonal system B.
Cdt=C*P                             % Calculate diagonal system C.
'Via Canon Command'                 % Display label.
S=ss(A,B,C,0)                       % Create state-space LTI object for 
                                    % original system.
Sp=canon(S,'modal')                 % Calculate diagonal system via canon 
                                    % command.
