% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch5p3): MATLAB can be used to convert transfer functions to state space in a 
% specified form. The command [Acc Bcc Ccc Dcc] = tf2ss(num,den) can be used to 
% convert T(s) = num/den into controller canonical form with matrices and 
% vectors Acc, Bcc, Ccc, and Dcc. We can then form an LTI state-space object using 
% Scc = ss(Acc,Bcc,Ccc,Dcc). This object can then be converted into parallel form 
% using Sp = canon(Scc,'type'), where type = modal yields the parallel form. Another 
% choice, not used here, is type = companion, which yields a right companion system 
% matrix. Transformation matrices can be used to convert to other representations. 
% As an example, let us convert C(s)/R(s) = 24/[(s+2)(s+3)(s+4)] into a parallel 
% representation in state space, as is done in Section 5.7 - Parallel Form. Notice 
% that the product of values in the B and C vectors yields the same product as the 
% results in Eqs. (5.49) and (5.50). Thus, the two solutions are the same, but the 
% state variables are ordered differently, and the gains are split between the 
% B and C vectors. We can also extract the system matrices from the LTI object using
% [A,B,C,D] = ssdata(S),where S is a state-space LTI object and A, B, C, D, are its 
% associated matrices and vectors.

'(ch5p3)'                           % Display label.
numt=24;                            % Define numerator of T(s).
dent=poly([-2 -3 -4]);              % Define denominator of T(s).
'T(s)'                              % Display label.
T=tf(numt,dent)                     % Create and display T(s).
[Acc Bcc Ccc Dcc]=tf2ss(numt,dent); % Convert T(s) to controller
                                    % canonical form.
Scc=ss(Acc,Bcc,Ccc,Dcc);            % Create LTI controller canonical
                                    % state-space object.
Sp=canon(Scc,'modal');              % Convert controller canonical form
                                    % to parallel form.
'Controller Canonical Form'         % Display label.
[Acc,Bcc,Ccc,Dcc]=ssdata(Scc)       % Extract and display controller
                                    % canonical form matrices.
'Parallel Form'                     % Display label.
[Ap,Bp,Cp,Dp]=ssdata(Sp)            % Extract and display parallel form
                                    % matrices.
